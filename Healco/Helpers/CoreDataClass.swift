//
//  CoreData.swift
//  Healco
//
//  Created by Fahmi Dzulqarnain on 22/07/21.
//

import Foundation
import CoreData

class CoreDataClass {
    
    // MARK: Contoh Implementasi CoreData
    // let data = CoreData()
    // let journals = data.fetchJournalBaseOnDay(tanggalWaktu: Date())
    
    let manager = CoreDataManager.instance
    let context: NSManagedObjectContext
    
    init() { context = manager.context }
    
    // MARK: Nah, kalau ini function untuk journal!
    
    func fetchJournal() -> [JournalEntity]{
        do {
            return try context.fetch(NSFetchRequest<JournalEntity>(entityName: "JournalEntity"))
        } catch let error {
            print("Error nih pas ngambil data jurnalnya, nih detailnya \(error)")
            return []
        }
    }
    
    func fetchJournalBaseOnDay(tanggalWaktu: Date) -> [JournalEntity]{ //Date() -> tipe datenya
        do {
            let request = NSFetchRequest<JournalEntity>(entityName: "JournalEntity")
            request.predicate = NSPredicate(format: "tanggal_jam == %@", tanggalWaktu as NSDate)
            return try context.fetch(request)
        } catch let error {
            print("Error nih pas ngambil data jurnalnya, nih detailnya \(error)")
            return []
        }
    }
    
    func fetchJournalBaseOnDayAndType(tanggalWaktu: Date, tipe: String) -> [JournalEntity]{
        do {
            let request = NSFetchRequest<JournalEntity>(entityName: "JournalEntity")
            request.predicate = NSPredicate(format: "tanggal_jam == %@ AND tipe == %@", tanggalWaktu as NSDate, tipe)
            return try context.fetch(request)
        } catch let error {
            print("Error nih pas ngambil data jurnalnya, nih detailnya \(error)")
            return []
        }
    }
    
    // Ini Add Journal yang masih polos, gak pakai makanan yang udah kesimpen -> pake yang ini dulu gais
    
    func addJournal(lagiApa: String, perasaan: String, porsi: Double,
                    satuan: String, tanggalJam: Date, tipe: String,
                    // Ini parameter untuk nambahin makanan
                    idMeal: String, nama: String, deskripsi: String,
                    karbohidrat: Int32, lemak: Int32, protein: Int32, gambar: String, kaloriTotal: Int32, lemakTotal: Int32, proteinTotal: Int32, karbohidratTotal: Int32, kalori: Int32){
        let newJournal = JournalEntity(context: context)
        newJournal.lagi_apa = lagiApa
        newJournal.perasaan = perasaan
        newJournal.porsi = porsi
        newJournal.satuan = satuan
        newJournal.tanggal_jam = tanggalJam
        newJournal.tipe = tipe
        newJournal.kaloriTotal = kaloriTotal
        newJournal.lemakTotal = lemakTotal
        newJournal.karbohidratTotal = karbohidratTotal
        newJournal.proteinTotal = proteinTotal
        newJournal.id_meal = idMeal
        newJournal.deskripsi = deskripsi
        newJournal.gambar = gambar
        newJournal.kalori = kalori
        newJournal.karbohidrat = karbohidrat
        newJournal.lemak = lemak
        newJournal.protein = protein

//        newJournal.meal = addMeal(idMeal: idMeal, nama: nama, deskripsi: deskripsi,
//                                  kalori: kalori, karbohidrat: karbohidrat, lemak: lemak,
//                                  protein: protein, gambar: gambar)
        print("addJournal")
        
        saveData()
    }
    
    // Nah kalau ini Add Journal yang ngambil makanan yang udah ada
    
    func addJournal(lagiApa: String, perasaan: String, porsi: Double,
                    satuan: String, tanggalJam: Date, tipe: String/*, meal: MealEntity*/, kaloritotal: Int32, proteintotal: Int32){
        let newJournal = JournalEntity(context: context)
        newJournal.lagi_apa = lagiApa
        newJournal.perasaan = perasaan
        newJournal.porsi = porsi
        newJournal.satuan = satuan
        newJournal.tanggal_jam = tanggalJam
        newJournal.tipe = tipe
        newJournal.kaloriTotal = kaloritotal
        newJournal.proteinTotal = proteintotal
        //newJournal.meal = meal

        saveData()
    }
    
    func updateJournal(journal: JournalEntity, lagiApa: String, perasaan: String, porsi: Double,
                       satuan: String, tanggalJam: Date, tipe: String, kalori: Int32){
        journal.lagi_apa = lagiApa
        journal.perasaan = perasaan
        journal.porsi = porsi
        journal.satuan = satuan
        journal.tanggal_jam = tanggalJam
        journal.tipe = tipe
        // Ntar tinggal tambah aja sesuai kebutuhan, mau ngeupdate meal nya gimana
        journal.meal?.kalori = kalori
        
        saveData()
    }
    
    func deleteJournal(journal: JournalEntity){
        context.delete(journal)
        saveData()
    }
    
    // MARK: Kalau yang disini function untuk meal yak.. // belum di pake
    
    func addMeal(idMeal: String, nama: String, deskripsi: String, kalori: Int32,
                 karbohidrat: Int32, lemak: Int32, protein: Int32, gambar: String) -> MealEntity{
        let newMeal = MealEntity(context: context)
        newMeal.id_meal = idMeal
        newMeal.nama = nama
        newMeal.deskripsi = deskripsi
        newMeal.kalori = kalori
        newMeal.karbohidrat = karbohidrat
        newMeal.lemak = lemak
        newMeal.protein = protein
        newMeal.gambar = gambar
        
        saveData()
        return newMeal
    }
    
    func sumKalori(tanggalJurnal: Date) -> Int32 {
        var kaloriPerDay : Int32 = 0

        // Bikin expression buat ngambil jumlah datanya

        let expression = NSExpressionDescription()
        expression.expression =  NSExpression(forFunction: "sum:", arguments:[NSExpression(forKeyPath: "kaloriTotal")])
        expression.name = "kaloriPerDay";
        expression.expressionResultType = NSAttributeType.doubleAttributeType

        // Ambil dari JournalEntity berdasarkan tanggalnya deh
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "JournalEntity")
        request.predicate = NSPredicate(format: "tanggal_jam == %@", tanggalJurnal as NSDate)
        request.propertiesToFetch = [expression]
        request.resultType = NSFetchRequestResultType.dictionaryResultType

        // Nah, sekarang tinggal ambil aje penjumlahan kalorinya

        do {
            let results = try context.fetch(request)
            let resultMap = results[0] as! [String:Double]
            kaloriPerDay = Int32(resultMap["kaloriPerDay"]!)
        } catch let error as NSError {
            NSLog("Error pas ngejumlahin kalorinya: \(error.localizedDescription)")
        }

        return kaloriPerDay
    }
    
    func getPercentage(macroNutrient: MacroNutrient, tanggalJurnal: Date) -> String {
        let karbohidrat: Int32 = getSumOfMacroNutrient(macroNutrient: .karbohidrat, tanggalJurnal: tanggalJurnal)
        let lemak : Int32 = getSumOfMacroNutrient(macroNutrient: .lemak, tanggalJurnal: tanggalJurnal)
        let protein : Int32 = getSumOfMacroNutrient(macroNutrient: .protein, tanggalJurnal: tanggalJurnal)
        let total : Int32 = karbohidrat + lemak + protein
        var hasilnya : Int32 = 0
        
        print("karbo ", karbohidrat)
        print("lemak ",  lemak)
        print("protein ",  protein)

        if(karbohidrat != 0 && lemak != 0 && protein != 0){
            switch macroNutrient {
            case .karbohidrat:
                hasilnya = karbohidrat / total * 100
            case .lemak:
                hasilnya = lemak / total * 100
            case .protein:
                hasilnya = protein / total * 100
            }
        } else {
            hasilnya = 0
            print("default sama dengan nol")
        }
        
        return "\(hasilnya)%"
    }
    
    func getSumOfMacroNutrient(macroNutrient: MacroNutrient, tanggalJurnal: Date) -> Int32 {
        var hasilnya : Int32 = 0
        let keyPath = macroNutrient.rawValue
        
        print("keypath ",keyPath)
        let expression = NSExpressionDescription()
        expression.expression =  NSExpression(forFunction: "sum:", arguments:[NSExpression(forKeyPath: keyPath)])
        expression.name = "\(keyPath)PerDay";
        expression.expressionResultType = NSAttributeType.doubleAttributeType
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "JournalEntity")
        //request.predicate = NSPredicate(format: "tanggal_jam == %@", tanggalJurnal as NSDate)
        request.propertiesToFetch = [expression]
        request.resultType = NSFetchRequestResultType.dictionaryResultType
        
        do {
            let results = try context.fetch(request)
            let resultMap = results[0] as! [String:Int32]
            hasilnya = resultMap["\(keyPath)PerDay"]!
        } catch let error as NSError {
            NSLog("Error pas jumlahin \(keyPath): \(error.localizedDescription)")
        }
        print("hasil makro nutrient ", hasilnya)
        return hasilnya
    }
    
    // MARK: Nah, ada juga untuk nambah history.. Contohnya mau nambah perubahan berat badan, atau tinggi badan
    
    func addHistory(tipe: String, tanggal: Date, angka: Double){
        let history = HistoricalEntity(context: context)
        history.tipe = tipe
        history.tanggal = tanggal
        history.angka = angka
    
        saveData()
    }
    
    func updateHistory(history: HistoricalEntity, tipe: String, tanggal: Date, angka: Double){
        history.tipe = tipe
        history.tanggal = tanggal
        history.angka = angka
    
        saveData()
    }
    
    func deleteHistory(history: HistoricalEntity){
        context.delete(history)
        saveData()
    }
    
    // MARK: Untuk ngambil data profile, ini function nya
    
    func fetchProfile() -> [ProfileEntity]{
        do {
            return try context.fetch(NSFetchRequest<ProfileEntity>(entityName: "ProfileEntity"))
        } catch let error {
            print("Error nih pas ngambil data jurnalnya, nih detailnya \(error)")
            return []
        }
    }
    
    func addProfile(nama_pengguna: String, gender: String, tanggalLahir: Date,
                    tinggiBadan: Int32, beratBadan: Double){
        let profile = ProfileEntity(context: context)
        profile.nama_pengguna = nama_pengguna
        profile.gender = gender
        profile.tanggal_lahir = tanggalLahir
        profile.tinggi_badan = tinggiBadan
        profile.berat_badan = beratBadan
        
        saveData()
    }
    
    func changeProfile(profile: ProfileEntity, nama_pengguna: String, gender: String, tanggalLahir: Date,
                       tinggiBadan: Int32, beratBadan: Double){
        profile.nama_pengguna = nama_pengguna
        profile.gender = gender
        profile.tanggal_lahir = tanggalLahir
        profile.tinggi_badan = tinggiBadan
        profile.berat_badan = beratBadan
        
        saveData()
    }
    
    func changeWeight(profile: ProfileEntity, beratBadan: Double){
        profile.berat_badan = beratBadan
        saveData()
    }
    
    func changeHeight(profile: ProfileEntity, tinggiBadan: Int32){
        profile.tinggi_badan = tinggiBadan
        saveData()
    }
    
    // MARK: Ini Fungsi Untuk Ngatur Notifikasi Input Jurnal
    
    func fetchNotification() -> NotificationEntity? {
        do {
            return try context.fetch(NSFetchRequest<NotificationEntity>(entityName: "NotificationEntity"))[0]
        } catch let error {
            print("Error nih pas ngambil data notifikasinya, detailnya \(error)")
            return nil
        }
    }
    
    func addNotif(sarapanOn: Bool, sarapanTime: String, siangOn: Bool,
                  siangTime: String, malamOn: Bool, malamTime: String) {
        let notif = NotificationEntity(context: context)
        notif.sarapanOn = sarapanOn
        notif.sarapanTime = sarapanTime
        notif.siangOn = siangOn
        notif.siangTime = siangTime
        notif.malamOn = malamOn
        notif.malamTime = malamTime
        
        saveData()
    }
    
    func updateNotif(notifEntity: NotificationEntity, timeType: String, isOn: Bool, time: String){
        if timeType == "Sarapan" {
            notifEntity.sarapanOn = isOn
            notifEntity.sarapanTime = time
        } else if timeType == "Makan Siang" {
            notifEntity.sarapanOn = isOn
            notifEntity.sarapanTime = time
        } else if timeType == "Makan Malam" {
            notifEntity.sarapanOn = isOn
            notifEntity.sarapanTime = time
        }
        
        saveData()
    }
    
    
    // MARK: Yang terakhir, ini function buat core data secara umum
    
    func saveData(){
        manager.saveData()
    }
}

class CoreDataManager {
    
    static let instance = CoreDataManager()
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    init() {
        container = NSPersistentContainer(name: "CapmealDataModel")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Yah, Core Data nya error nih! \(error)")
            }
        }
        context = container.viewContext
    }
    
    func saveData(){
        do {
            try context.save()
        } catch let error {
            print("Ada masalah pas nyimpan data. Nih detailnya: \(error)")
        }
    }
}

enum TipeMakan : String {
    case sarapan = "Sarapan"
    case makanSiang = "Makan Siang"
    case makanMalam = "Makan Malam"
    case cemilan = "Cemilan"
}

enum MacroNutrient : String {
    case karbohidrat = "karbohidratTotal"
    case lemak = "lemakTotal"
    case protein = "proteinTotal"
}
