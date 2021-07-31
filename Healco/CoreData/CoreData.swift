//
//  CoreData.swift
//  Healco
//
//  Created by Fahmi Dzulqarnain on 22/07/21.
//

import Foundation
import CoreData

class CoreData {
    
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
    
    func fetchJournalBaseOnDay(tanggalWaktu: Date) -> [JournalEntity]{
        do {
            let request = NSFetchRequest<JournalEntity>(entityName: "JournalEntity")
            request.predicate = NSPredicate(format: "tanggalJam == %@", tanggalWaktu as NSDate)
            return try context.fetch(request)
        } catch let error {
            print("Error nih pas ngambil data jurnalnya, nih detailnya \(error)")
            return []
        }
    }
    
    func fetchJournalBaseOnDayAndType(tanggalWaktu: Date, tipe: String) -> [JournalEntity]{
        do {
            let request = NSFetchRequest<JournalEntity>(entityName: "JournalEntity")
            request.predicate = NSPredicate(format: "tanggalJam == %@ AND tipe == %@", tanggalWaktu as NSDate, tipe)
            return try context.fetch(request)
        } catch let error {
            print("Error nih pas ngambil data jurnalnya, nih detailnya \(error)")
            return []
        }
    }
    
    // Ini Add Journal yang masih polos, gak pakai makanan yang udah kesimpen
    
    func addJournal(lagiApa: String, perasaan: String, porsi: Double,
                    satuan: String, tanggalJam: Date, tipe: String,
                    // Ini parameter untuk nambahin makanan
                    idMeal: String, nama: String, deskripsi: String, kalori: Int32,
                    karbohidrat: Int32, lemak: Int32, protein: Int32, gambar: Data){
        let newJournal = JournalEntity(context: context)
        newJournal.lagi_apa = lagiApa
        newJournal.perasaan = perasaan
        newJournal.porsi = porsi
        newJournal.satuan = satuan
        newJournal.tanggal_jam = tanggalJam
        newJournal.tipe = tipe
        newJournal.meal = addMeal(idMeal: idMeal, nama: nama, deskripsi: deskripsi,
                                  kalori: kalori, karbohidrat: karbohidrat, lemak: lemak,
                                  protein: protein, gambar: gambar)
        
        saveData()
    }
    
    // Nah kalau ini Add Journal yang ngambil makanan yang udah ada
    
    func addJournal(lagiApa: String, perasaan: String, porsi: Double,
                    satuan: String, tanggalJam: Date, tipe: String, meal: MealEntity){
        let newJournal = JournalEntity(context: context)
        newJournal.lagi_apa = lagiApa
        newJournal.perasaan = perasaan
        newJournal.porsi = porsi
        newJournal.satuan = satuan
        newJournal.tanggal_jam = tanggalJam
        newJournal.tipe = tipe
        newJournal.meal = meal
        
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
    
    // MARK: Kalau yang disini function untuk meal yak..
    
    func addMeal(idMeal: String, nama: String, deskripsi: String, kalori: Int32,
                 karbohidrat: Int32, lemak: Int32, protein: Int32, gambar: Data) -> MealEntity{
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
    
    func fetchProfile() -> ProfileEntity{
        do {
            return try context.fetch(NSFetchRequest<ProfileEntity>(entityName: "ProfileEntity"))[0]
        } catch let error {
            print("Error nih pas ngambil data jurnalnya, nih detailnya \(error)")
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
        container = NSPersistentContainer(name: "CapmealModel")
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
