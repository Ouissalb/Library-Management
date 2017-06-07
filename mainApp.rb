
require 'io/console'
require 'csv'
class  Test


=begin
************************************************************
********************* ADHERENT CLASS ***********************
************************************************************
=end

  class Adherent
    attr_accessor :nom
    attr_accessor :prenom
    attr_accessor :statut
    attr_accessor :emprunts
    @@prenomMember = Array.new
    statut = {}
    statut[:ETUDIANT] = "ETUDIANT"
    statut[:ENSEIGNANT] = "ENSEIGNANT"
    @@membersInfo = Hash.new("")

    def initialize(nom, prenom, statut)
      @nom = nom
      @prenom = prenom
      @emprunts = []
      stat = 0
      @statut = statut
        if statut != "ETUDIANT" and statut != "ENSEIGNANT"
          loop do
            puts "Invalid status, try again :"
            puts "1- ETUDIANT"
            puts "2 - ENSEIGNANT"
            stat = gets.chomp.to_i
            break if stat == 1 || stat == 2
          end
          if stat == 1
            @statut = "ETUDIANT"
          elsif stat == 2
            @statut = "ENSEIGNANT"
          end
        end
        @@membersInfo[nom] = @@prenomMember.join(" , ")
        @@prenomMember[0] = prenom
        @@prenomMember[1] = statut
    end

    def maxEmpruntsReached
      if emprunts.length >= 5 then return true
      else return false
      end
    end

    def maxLaptopReached
      if (emprunts.include? 'LINUX') || (emprunts.include? 'WINDOWS') then return true
      else return false
      end
    end

    def printAdherent
      puts "Last name : #{nom}, First name : #{prenom}, #{statut}"
    end

    def rendreLivre(titre, biblio)
        biblio.emprunts.delete(titre)
=begin
        livre = biblio.emprunts.searchBookByTitle(titre)
        livre.setAvailability(true)
=end
        puts "#{titre} was successfully returned .."
    end

    def rendreLaptop(marque, biblio)
        biblio.emprunts.delete(marque)
=begin
        laptop = biblio.searchLaptopByModel(marque)
        laptop.setAvailability(true)
=end
        puts "#{marque} was successfully returned .."
    end

    def emprunterLivre(titre, biblio)

      if(Livre.bookExists(titre) == true) then
         if(maxEmpruntsReached == false) then

          livre = biblio.searchBookByTitle(titre)

            if(livre.getAvailability == true)then

                @emprunts.insert(-1, livre)
                biblio.addEmprunt(livre, self)
                biblio.emprunts.insert(-1, livre.titre)
                livre.setAvailability(false)
                livre.member = self
               puts "#{titre} is now borrowed by #{self.nom} "
              else
                raise(DejaEmrpunte,"This book is already borrowed")
              end
            else
               raise(MaxEmprunts,"You can only borrow 5 books ")
            end
          else
              raise(Inconnu,"NOT FOUND")
          end
        end

    def emprunterLaptop(marque, biblio)
      if(OrdinateurPortable.laptopExists(marque) == true) then
         if(maxLaptopReached == false) then
          laptop = biblio.searchLaptopByModel(marque)
            if(laptop.getAvailability == true)then
              @emprunts.insert(-1, laptop)
                biblio.addEmprunt(laptop, self)
                laptop.setAvailability(false)
                biblio.emprunts.insert(-1, laptop.marque)
                laptop.member = self
               puts "#{marque} is now borrowed by #{self.nom} "
              else
                raise(DejaEmrpunte,"This laptop was already borrowed")
              end
            else
               raise(MaxEmprunts,"You can only borrow 5 books ")
            end
          else
              raise(Inconnu,"NOT FOUND")
          end
    end

    def rendre
    end

    def afficherEmprunts
      puts emprunts
    end

    def self.printMembers
      @@membersInfo.each do |key, value|
      puts "#{key} : #{value}"
    end
    end
    def to_s
      "Nom : #{nom}, Prenom : #{prenom}, Statut: #{statut}"
    end



  end

=begin
  ************************************************************
  *******************  EMPRUNTABLE MODULE  *******************
  ************************************************************
=end

  module Empruntable
    attr_accessor :member
    $isAvailable
    $tempAv
    def isDisponible?
      if $isAvailable ? true : false
      end
    end
    def self.printAv
      if $isAvailable
        $tempAv = "Available"
      else
        $tempAv = "Not available"
      end
    end
  end

=begin
  ************************************************************
  ********************* MATERIEL CLASS ***********************
  ************************************************************
=end

class Materiel

  attr_accessor :enPanne

  def initialize(enpanne = false)
      @enpanne = enpanne
  end

  def enpanne
      if enPanne ? true : false
  	  end
  end
end

=begin
  ************************************************************
  **********************  LAPTOP CLASS  **********************
  ************************************************************
=end

  class OrdinateurPortable < Materiel

    include Empruntable

    attr_reader :marque
    attr_reader :os
    os = {}
    os[:LINUX] = "LINUX"
    os[:WINDOWS] = "WINDOWS"

    @@laptopsInfo = Hash.new
    @@numberOfLaptops = 0
    @@etatLaptop = Array.new

    def initialize(marque ,os , isAvailable = true, enPanne = false )
      super(enpanne)

      @isAvailable    =   isAvailable
      @marque         =   marque

      if os != "LINUX" and os != "WINDOWS"
        loop do
          puts "Invalid operating system, try again :"
          puts "1- LINUX"
          puts "2 - WINDOWS"
          enteredOs = gets.chomp.to_i
          break if enteredOs == 1 || enteredOs == 2
        end
        if enteredOs == 1
          @os = "LINUX"
        elsif enteredOs == 2
          @os = "WINDOWS"
        end
      end

      $isAvailable = isAvailable
      puts $isAvailable
      @@numberOfLaptops += 1
      if enPanne == false then   @@etatLaptop[0] = "Not working"
      else   @@etatLaptop[0] = "Working"
      end
      if isAvailable == false then @@etatLaptop[1] ="Not available"
      else   @@etatLaptop[1] = "available"
      end
      @@etatLaptop[2] = os
      @@laptopsInfo[marque] = @@etatLaptop.join(" => ")
      puts @marque + " "+ " was successfully added"
    end

    def getAvailability
      $isAvailable
    end

    def setAvailability(a)
      if (a == true) then $isAvailable = true
      else $isAvailable = false
      end
    end

    def printLaptop
      puts "#{marque} + " " + #{os}"
    end

    def self.laptopExists(marque)
      if (@@laptopsInfo[marque] != nil) then return  true
      else return false
      end
    end


    def to_s
=begin
      @marque+" "+@os+" "+@isAvailable.to_s + " "+@enPanne
=end
      OrdinateurPortable.printLaptops
    end

    def self.printLaptops
      @@laptopsInfo.each do |key, value|
      puts "#{key} : #{value}"
      end
    end

    def self.addLaptop
      $avLaptop = true
      $enPanne = false
      puts"Enter the laptop's model :"
      modelSaisi = gets.chomp
      puts"Enter the laptop's OS :"
      puts "1- LINUX"
      puts "2 - WINDOWS"
      osSaisi = gets.chomp.to_i
      if osSaisi == 1
        osLaptop = "LINUX"
      elsif osSaisi == 2
        osLaptop = "WINDOWS"
      end

      puts"Is it available? (y/n)"
      loop do
        $avLaptop = gets.chomp.to_s
        unless $avLaptop == 'y' || $avLaptop == 'n'
          puts "Error: Invalid entry. Please enter either 'y' or 'n'"
        end
        break if $avLaptop == 'y' || $avLaptop == 'n'
      end
        if $avLaptop == 'y' ? $avLaptop = true : $avLaptop = false
        end

      puts"Does it work? (y/n)"

      loop do
        $enPanne = gets.chomp.to_s
        unless $enPanne == 'y' || $enPanne == 'n'
          puts "Error: Invalid entry. Please enter either 'y' or 'n'"
        end
        break if $enPanne == 'y' || $enPanne == 'n'
      end
        if $enPanne == 'y' ? $enPanne = true : $enPanne = false
        end

      laptop = OrdinateurPortable.new(modelSaisi, osLaptop, $avLaptop, $enPanne)

    end

  end

=begin
  ************************************************************
  ********************* DOCUMENT CLASS  **********************
  ************************************************************
=end

  class Document
    attr_reader :titre
    def initialize(titre)
      @titre = titre
    end
  end

=begin
    ************************************************************
    ********************* MAGAZINE CLASS  **********************
    ************************************************************
=end

  class Revue < Document
    attr_reader :numero
    @@numberOfNovels = 2
    @@novelsInfo = Hash.new
    def initialize(numero, titre)
      super(titre)
      @numero = numero
      @@numberOfNovels += 1
      num = "#{numero}"
      @@novelsInfo[numero] = titre
    end
    def editRevue(numero)
      self.numero = numero
    end
    def printRevue
      puts "Revue N° #{numero}, #{@@novelsInfo[numero].values}"
    end
    def to_s
      @numero + ","+ @@novelsInfo[numero].values
    end
    def self.printRevues
      @@novelsInfo.each do |key, value|
      puts "#{key} : #{value}"
    end
    end
    def self.howManyNovels
      @@numberOfNovels
    end
    def self.addRevue
      puts"Enter the magazine's number :"
      numRevueSaisi = gets.chomp.to_i
      puts"Enter the magazine's title"
      titreRevueSaisi = gets.chomp
      revue = Revue.new(numRevueSaisi, titreRevueSaisi)
      puts"#{titreRevueSaisi} was successfully added"
    end
  end

=begin
    ************************************************************
    ********************* VOLUME CLASS  ************************
    ************************************************************
=end

  class Volume < Document
      attr_accessor :auteur
      @@idAuteurs = 0
      @@listeAuteurs = Hash.new
      def initialize(titre, auteur)
        super(titre)
        @auteur = auteur
        @@idAuteurs += 1
        @@listeAuteurs[@@idAuteurs] = auteur
      end

      def self.addAuthor(nom)
        @@idAuteurs += 1
        @@listeAuteurs[@@idAuteurs] = nom
        puts @@listeAuteurs
        puts "#{nom} was successfully added to the list of authors"
      end

      def self.printAuthors
        puts "Authors list :"
        @@listeAuteurs.each do | key , value|
          puts "#{key} : #{value}"
        end
      end

      def self.searchAuthorByID (id)
        puts "Searching for ID = #{id} .... "
        if @@listeAuteurs[id] == nil ? (puts "NOT FOUND") : (puts "FOUND : #{@@listeAuteurs[id]}")
        end
      end


  end

=begin
    ************************************************************
    *********************** COMICS CLASS  **********************
    ************************************************************
=end

  class BandeDessine < Volume
    attr_accessor :dessinateur
    @@numberOfComics = 2
    @@comicsInfo = Hash.new
    @@titreAuteur = Array.new

    def initialize(titre, auteur, dessinateur)
      super(titre, auteur)
      @dessinateur = dessinateur
      @@numberOfComics += 1
      @@titreAuteur[0] = titre
      @@titreAuteur[1] = auteur
      @@comicsInfo[dessinateur] = @@titreAuteur.join(" , ")
    end

    def howManyComics
      @@numberOfComics
    end

    def to_s
      @titre +" - "+@auteur+" - "+@dessinateur
    end

    def self.printComics
      @@comicsInfo.each do |key, value|
      puts "#{key} : #{value}"
      end
    end

    def self.addComic
      puts"Enter the comic's author :"
      nomAuthorSaisi = gets.chomp
      puts"Enter the comic's title"
      titreComicSaisi = gets.chomp
      puts"Enter the comic's illustrator"
      illustComicSaisi = gets.chomp
      comic = BandeDessine.new(titreComicSaisi, nomAuthorSaisi, illustComicSaisi )
      puts"#{titreComicSaisi} was successfully added"
    end

  end

=begin
    ************************************************************
    ********************* DICTIONARY CLASS  ********************
    ************************************************************
=end

  class Dictionnaire < Volume
    attr_accessor :theme
    @@numberOfDict = 2
    @@dictInfo = Hash.new
    @@titreAuteur = Array.new

    def initialize(theme, titre, auteur)
      super(titre, auteur)
      @theme = theme
      @@numberOfDict += 1
      @@titreAuteur[0] = titre
      @@titreAuteur[1] = auteur
      @@dictInfo[theme] = @@titreAuteur.join(" , ")
    end

    def howManyDict
      @@numberOfDict
    end

    def self.printDict
      @@dictInfo.each do |key, value|
      puts "#{key} : #{value}"
      end
    end
    def to_s
      @titre + " - "+ @auteur + " - " + @theme
    end
    def self.addDict
      puts"Enter the dictionary's author :"
      nomAuthorSaisi = gets.chomp
      puts"Enter the dictionary's title"
      titreDictSaisi = gets.chomp
      puts"Enter the dictionary's theme"
      themeComicSaisi = gets.chomp
      dict = Dictionnaire.new(titreDictSaisi, nomAuthorSaisi, themeComicSaisi )
      puts"#{titreDictSaisi} was successfully added"
    end

  end

=begin
    ************************************************************
    ********************* BOOK CLASS  **************************
    ************************************************************
=end

  class Livre < Volume
    include Empruntable
    @@booksInfo = Hash.new
    @@numberOfBooks = 2
    @@titreAuteur = Array.new
    def initialize(titre ,auteur , isAvailable = "true" )
      super(titre, auteur)
      $isAvailable = isAvailable
      @@numberOfBooks += 1
      @@titreAuteur[0] = auteur
      @@titreAuteur[1] = Empruntable.printAv
      @@booksInfo[titre] = @@titreAuteur.join(" => ")
    end

    def getAvailability
      $isAvailable
    end

    def setAvailability(a)
      if (a == true) then $isAvailable = true
      else $isAvailable = false
      end
    end

    def self.bookExists(titre)
      if (@@booksInfo[titre] != nil) then return  true
      else return false
      end
    end

=begin
    def self.searchBook(titre)
      if @@booksInfo[titre] != nil ? @@booksInfo[titre] : (puts "doesn't exist")
      end
    end
=end

    def to_s
      @titre+" "+@auteur+" "+@isAvailable.to_s
    end

    def self.printBooks
      @@booksInfo.each do |key, value|
      puts "#{key} : #{value}"
      end
    end

    def self.addBook
      $avBook = true
      puts"Enter the author's name :"
      authorSaisi = gets.chomp
      puts"Enter the book's title :"
      titreBookSaisi = gets.chomp
      puts"Is it available? (y/n)"
      loop do
        $avBook = gets.chomp.to_s
        unless $avBook == 'y' || $avBook == 'n'
          puts "Error: Invalid entry. Please enter either 'y' or 'n'"
        end
        break if $avBook == 'y' || $avBook == 'n'
      end
        if $avBook == 'y' ? $avBook = true : $avBook = false
        end

        book = Livre.new(titreBookSaisi, authorSaisi, $avBook)
        puts"#{titreBookSaisi} was successfully added"
    end

  end

=begin
    ************************************************************
    ********************* LIBRARY CLASS  ***********************
    ************************************************************
=end

  class Bibliotheque
    attr_accessor :members
    attr_accessor :members2
    attr_accessor :laptops
    attr_accessor :documents
    attr_accessor :lentItems
    attr_accessor :emprunts
    attr_accessor :books
    attr_accessor :laptops2
    @@empruntsInfos = Hash.new()
    def initialize
      @members = Hash.new()
      @members2 = Hash.new()
      @laptops = Hash.new()
      @documents = Hash.new()
      @lentItems = Hash.new()
      @books = Hash.new()
      @laptops = Hash.new()
      @laptops2 = Hash.new()
      @emprunts = Array.new()
      @isbn = Hash.new()
      @@ISBN = 34674285
      @@iDlaptops = 0
      @@IDmember = 0
      @@IDs = 0
    end


    def addEmprunt(book, membre)
      @@empruntsInfos[book] = membre
      puts " "
      puts "List of borrowed books/laptops : "
      puts " "
      puts @@empruntsInfos.to_a
    end

    def addAdherent(adherent)
      @@IDmember += 1
      @members[@@IDmember] = adherent.to_s
      @members2[@@IDmember] = adherent
      puts "member successfully added to the library"
    end

    def searchBookByid(id)
      if @documents[id] == nil ? false : true
      end
    end

    def searchMemberByID (id)
      if @members[id] == nil ? (puts "NOT FOUND") : (puts "FOUND : #{@members[id]}")
      end
    end

    def searchMemberByID2 (id)
      if @members2[id] == nil then (puts "NOT FOUND")
      else return @members2[id]
      end
    end


    def searchDocByISBN(isbn)
      if @isbn[isbn] == nil ? (puts "NOT FOUND") : (puts "FOUND : #{@isbn[isbn]}")
      end
    end

    def searchLaptopByID(iDlaptop)
      if @laptops[iDlaptop] == nil ? (puts "NOT FOUND") : (puts "FOUND : #{@laptops[iDlaptop].to_a.join(" => ")}")
      end
    end

    def searchBookByTitle (title)
      if @books[title] == nil then (puts "NOT FOUND")
      else return @books[title]
      end
    end

    def searchLaptopByModel (model)
      if @laptops2[model] == nil then (puts "NOT FOUND")
      else return @laptops2[model]
      end
    end

    def addLaptop(laptop)
      @laptops2[laptop.marque] = laptop
    end

    def addBook(book)
      @books[book.titre] = book
    end

    def addDocument(document)
      @@IDs += 1
      @@ISBN += 1
      @documents[@@IDs] = document.to_s
      @isbn[@@ISBN] = @documents[@@IDs].to_s
      puts "Document successfully added to the library"
    end
    def addMateriel(materiel)
      @laptops[@@iDlaptops] = materiel.to_s
      @laptops2[materiel.marque] = materiel
      puts "laptop successfully added to the library"
    end

    def displayMembers
      @members.each do |key, value|
        puts "#{key} : #{value}"
      end
    end

    def displayDocuments
      @documents.each do |key, value|
        puts "#{key} : #{value}"
      end
    end

    def displayLaptops
      @laptops.each do |key, value|
        puts "#{key} : #{value.to_a.join(" => ")}"
      end
    end

    def deleteMember(id)
      if @members.delete(id) != nil
        puts "Deleted .."

      else
        raise(Inconnu,"This member doesn't exist")
      end
    end

    def deleteDocument (id)
      if @documents.delete(id) != nil
        puts "Deleted .."
      else
        raise(Inconnu,"This document doesn't exist")
      end
    end
    def deleteLaptop(id)
      if @laptops.delete(id) != nil
        puts "Deleted .."
      else
        raise(Inconnu,"This laptop doesn't exist")
      end
    end



  end

  class Inconnu < RuntimeError
  end

  class Indisponible < RuntimeError
  end

  class MaxEmprunts < RuntimeError
  end

  class PasEmpruntable < RuntimeError
  end

  class DejaEmrpunte < RuntimeError
  end

=begin
    ************************************************************
    ********************* MAIN PROGRAM !  **********************
    ************************************************************
=end

  biblio = Bibliotheque.new
  adherent1 = Adherent.new("Ruiz", "Ann", "ETUDIANT")
  adherent2 = Adherent.new("Miller", "Julia", "ENSEIGNANT")
  biblio.addAdherent(adherent1)
  biblio.addAdherent(adherent2)
  revue1 = Revue.new(1585, "Imagine demain le monde")
  revue2 = Revue.new(4787, "National Geographic")

  book1 = Livre.new("Hitchhikers guide to the galaxy", "Douglas Adams", true)
  book2 = Livre.new("Bones to Ashes", "Kathy Reichs", true)
  biblio.addDocument(book1)
  biblio.addDocument(book2)
  biblio.addBook(book1)
  biblio.addBook(book2)

  comic1 = BandeDessine.new("Batman Vol. 2", "Greg Capullo", "Jason Fabok")
  comic2 = BandeDessine.new("The Killing Joke", "Alan Moore", "Brian Bolland")
  biblio.addDocument(comic1)
  biblio.addDocument(comic2)

  dict1 = Dictionnaire.new("English", "A Dictionary of the English Language", "Samuel Johnson")
  dict2 =Dictionnaire.new("American English", "American College Dictionary ", "Clarence L. Barnhart")

  biblio.addDocument(dict1)
  biblio.addDocument(dict2)
=begin
  laptop1 = OrdinateurPortable.new("Toshiba L50", "LINUX", true, true)
  biblio.addMateriel(laptop1)
  biblio.addLaptop(laptop1)
=end

  Gem.win_platform? ? (system "cls") : (system "clear")



  puts "▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄ MENU 1 ▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄"
  puts " "
  puts "1- Lancer le menu 2 (une fonction à la fois)"
  puts "2- Test de toutes les fonctions du menu 2"
  puts "3- Lancer le Web Service fournissant le menu 2"
  puts "0- Quitter"
  puts " "
  puts "▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄"

  menu1Answer = nil
  loop do
    menu1Answer = gets.chomp.to_i
    unless (0..3) === menu1Answer
      puts "Error: Invalid entry. Please enter a number between 0 to 3"
    end
    break if (0..3) === menu1Answer
  end
  case menu1Answer
      when 1
        loop do
            Gem.win_platform? ? (system "cls") : (system "clear")
            puts "▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄ MENU 1 ▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄"
            puts " "
            puts "1- Add a member"
            puts "2- Add a book"
            puts "3- Add a laptop"
            puts "------------------------------------------------------------"
            puts "4- Search for a member by ID"
            puts "5- Search a document by an ISBN"
            puts "6- Search a laptop by ID"
            puts "------------------------------------------------------------"
            puts "7- Display all members"
            puts "8- Display all documents"
            puts "9- Display all laptops"
            puts "------------------------------------------------------------"
            puts "10- Add a person to authors"
            puts "11- Search authors by ID"
            puts "12- Display all authors IDs"
            puts "13- Display all materials IDs"
            puts "------------------------------------------------------------"
            puts "14- Remove a member"
            puts "15- Remove a material"
            puts "16- Remove a document"
            puts "------------------------------------------------------------"
            puts "17- Borrow a laptop"
            puts "18- Borrow a book"
            puts "------------------------------------------------------------"
            puts "19- Return a laptop"
            puts "20- Return a book"
            puts "------------------------------------------------------------"
            puts "21- Load library from CSV file"
            puts "22- Save library in CSV file"
            puts "------------------------------------------------------------"
            puts "23- War and peace book (select for more options)"
            puts "0- Exit"
            puts " "
            puts "▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄"
            menu2Answer = nil
            break if menu2Answer == 0
            loop do
              menu2Answer = gets.chomp.to_i
              unless (0..23) === menu2Answer
                puts "Error: Invalid entry. Please enter a number between 0 to 23"
              end
              break if (0..23) === menu2Answer
            end
            case menu2Answer
                when 1
                  Gem.win_platform? ? (system "cls") : (system "clear")
                  statut = ""
                  puts"Enter then member's first name :"
                  prenomSaisi = gets.chomp
                  puts"Enter the member's last name :"
                  nomSaisi = gets.chomp
                  puts"Enter the member's status : (select either 1 or 2 )  "
                  puts "1- ETUDIANT"
                  puts "2 - ENSEIGNANT"
                  stat = gets.chomp.to_i
                  if stat == 1
                    statut = "ETUDIANT"
                  elsif stat == 2
                    statut = "ENSEIGNANT"
                  end
                  membre = Adherent.new(nomSaisi, prenomSaisi, statut )
                  puts"#{nomSaisi} #{prenomSaisi} was successfully added as a member"
                  biblio.addAdherent(membre)
                  puts ""
                  puts "To go back press any key....."
                  pause = gets
                when 2
                  Gem.win_platform? ? (system "cls") : (system "clear")
                  biblio.addDocument(Livre.addBook)
                  puts ""
                  puts "To go back press any key....."
                  pause = gets
                when 3
                  Gem.win_platform? ? (system "cls") : (system "clear")
                  biblio.addMateriel(OrdinateurPortable.addLaptop)
                  puts ""
                  puts "To go back press any key....."
                  pause = gets
                when 4
                  puts "Enter an ID : "
                  idMember = gets.chomp.to_i
                  biblio.searchMemberByID(idMember)
                  puts ""
                  puts "To go back press any key....."
                  pause = gets
                when 5
                  puts "Enter an ISBN : (for example : 34674286) "
                  isbn = gets.chomp.to_i
                  biblio.searchDocByISBN(isbn)
                  puts ""
                  puts "To go back press any key....."
                  pause = gets
                when 6
                  puts "Enter an ID :  "
                  idlaptop = gets.chomp.to_i
                  biblio.searchLaptopByID(idlaptop)
                  puts ""
                  puts "To go back press any key....."
                  pause = gets
                when 7
                  biblio.displayMembers
                  puts ""
                  puts "To go back press any key....."
                  pause = gets
                when 8
                  biblio.displayDocuments
                  puts ""
                  puts "To go back press any key....."
                  pause = gets
                when 9
                  biblio.displayLaptops
                  puts ""
                  puts "To go back press any key....."
                  pause = gets
                when 10
                  puts " Author's name : "
                  nom = gets.chomp
                  Volume.addAuthor(nom)
                  puts ""
                  puts "To go back press any key....."
                  pause = gets
                when 11
                  puts "Enter an ID :  "
                  idAuthor = gets.chomp.to_i
                  Volume.searchAuthorByID(idAuthor)
                  puts ""
                  puts "To go back press any key....."
                  pause = gets
                when 12
                  Volume.printAuthors
                  puts ""
                  puts "To go back press any key....."
                  pause = gets
                when 13
                  biblio.displayLaptops
                  puts ""
                  puts "To go back press any key....."
                  pause = gets
                when 14
                  biblio.displayMembers
                  puts "Enter the ID of the member to delete : "
                  id = gets.chomp.to_i
                  biblio.deleteMember(id)
                  puts ""
                  puts "To go back press any key....."
                  pause = gets
                when 15
                  biblio.displayLaptops
                  puts "Enter the ID of the material to delete : "
                  id = gets.chomp.to_i
                  biblio.deleteLaptop(id)
                  puts ""
                  puts "To go back press any key....."
                  pause = gets
                when 16
                  biblio.displayDocuments
                  puts "Enter the ID of the document to delete : "
                  id = gets.chomp.to_i
                  biblio.deleteDocument(id)
                  puts ""
                  puts "To go back press any key....."
                  pause = gets
                when 17
                  biblio.displayMembers
                  puts "Enter the member's ID : "
                  id = gets.chomp.to_i
                  member = biblio.searchMemberByID2(id)
                  puts "Enter a laptop's model : "
                  model = gets.chomp
                  member.emprunterLaptop(model, biblio)
                  puts ""
                  puts "To go back press any key....."
                  pause = gets
                when 18
                  biblio.displayMembers
                  puts "Enter the member's ID : "
                  id = gets.chomp.to_i
                  member = biblio.searchMemberByID2(id)
                  puts "Enter a books title ( for example : 'Bones to Ashes')"
                  book = gets.chomp
                  member.emprunterLivre(book, biblio)
                  puts ""
                  puts "To go back press any key....."
                  pause = gets
                when 19
                  biblio.displayMembers
                  puts "Enter the member's ID : "
                  id = gets.chomp.to_i
                  member = biblio.searchMemberByID2(id)
                  puts "Quel laptop voulez vous rendre? "
                  laptop = gets.chomp
                  member.rendreLivre(laptop, biblio)
                  puts ""
                  puts "To go back press any key....."
                  pause = gets
                when 20
                  biblio.displayMembers
                  puts "Enter the member's ID : "
                  id = gets.chomp.to_i
                  member = biblio.searchMemberByID2(id)
                  puts "Quel livre voulez vous rendre? "
                  book = gets.chomp
                  member.rendreLaptop(book, biblio)
                  puts ""
                  puts "To go back press any key....."
                  pause = gets
                when 21
                  puts "What do you want to import? "
                  puts "1 - members"
                  puts "2- materials"
                  puts "3 - documents"
                  answerCSVL = gets.chomp.to_i
                  case answerCSVL
                  when 1

                       File.open("members.csv") do |fp|
                      fp.each do |line|
                      key, value = line.chomp.split(",")
                      biblio.members[key] = value
                      end
                      end

                  when 2

                     File.open("materials.csv") do |fp|
                      fp.each do |line|
                      key, value = line.chomp.split(",")
                      biblio.materials[key] = value
                      end
                      end

                  when 3

                     File.open("document.csv") do |fp|
                      fp.each do |line|
                      key, value = line.chomp.split(",")
                      biblio.document[key] = value
                      end
                      end

                end
                puts ""
                puts "successfully imported !"
                puts "To go back press any key....."
                pause = gets
                when 22

                      CSV.open("members.csv", "wb") {|csv|
                        biblio.members.to_a.each {|elem|
                          csv << elem} }

                      CSV.open("materials.csv", "wb") {|csv|
                        biblio.laptops.to_a.each {|elem|
                          csv << elem} }

                      CSV.open("document.csv", "wb") {|csv|
                        biblio.documents.to_a.each {|elem|
                          csv << elem} }

                puts "Library successfully saved"

                puts ""
                puts "To go back press any key....."
                pause = gets
                when 23
                  Dir.chdir(File.dirname(__FILE__))
                  bookContent = File.read("Livre.txt")
                  repeat = true
                  while repeat
                    Gem.win_platform? ? (system "cls") : (system "clear")
                    puts "1 - Count the number of times a particular word appears."
                    puts "2 - TOP 10 most used words in the book"
                    puts "3 - Count the number of times a particular string appears."
                    puts "4 - Exit"
                    puts "Pick a number (1 - 4)"
                    userChoice = gets.chomp.to_i
                    case userChoice
                    when 1
                        puts "\n Enter a word :"
                        mot1 = gets.chomp
                        $motCounter1 = 0
                        $motCounter2 = 0
                        puts "Searching for #{mot1} ..."
                        bookContent.split(/\W+/).each { |linesWords|
                            if linesWords.eql? mot1
                               $motCounter1 = $motCounter1 + 1
                            end
                        }
                        puts "The word #{mot1} appeared #{$motCounter1} times in this book"
                        puts "To go back press any key....."
                        pause = gets
                    when 2
                        tab = Hash.new(0);
                        bookContent.split(/\W+/).each { |linesWords|
                           tab[linesWords] = tab[linesWords] + 1
                        }
                        occ  = Hash[tab.sort_by{|k,v| v}]
                        puts "#{occ.max_by{|k,v| v}[1]}"
                        lastKey = occ.max_by{|k,v| v}[1]
                        last10 = occ.max_by{|k,v| v}[1] - 10
                        occ.keys[occ.size()-10..occ.size()].each { |key| puts "#{key} => #{occ[key]}" }
                        puts "To go back press any key....."
                        pause = gets
                    when 3
                      puts "\n Enter a word :"
                      mot1 = gets.chomp
                      puts "The string #{mot1} appeared #{bookContent.scan(/#{mot1}/).length} times in this book"
                      puts "To go back press any key....."
                      pause = gets
                    when 4
                      repeat = false
                    end
                  end


                  end
              end
            when 2
              puts "▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄TEST DES FONCTIONS ▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄"
              membre = Adherent.new("Benameur", "Ouissal", "ETUDIANT" )
              puts"Member successfully added"
              biblio.addAdherent(membre)
              biblio.searchMemberByID(1)
              biblio.searchDocByISBN(34674286)
              biblio.searchLaptopByID(1)
              puts "Library members : "
              biblio.displayMembers
              puts "Library documents : "
              biblio.displayDocuments
              puts "Library laptops :"
              biblio.displayLaptops
              puts "Adding a new author ... : "
              Volume.addAuthor("new author")
              puts " SEarching for an author .."
              Volume.searchAuthorByID(1)
              puts "All authors :"
              Volume.printAuthors
              biblio.displayLaptops
              puts "All members :"
              biblio.displayMembers
              puts "Deleting the member with ID = 1"
              biblio.deleteMember(1)
              biblio.displayLaptops
              puts "Display documents"
              biblio.displayDocuments
              puts "Deleting document with ID = 1"
              biblio.deleteDocument(1)
              puts "Borrow a book"
              member = biblio.searchMemberByID2(1)
              member.emprunterLivre("Bones to Ashes", biblio)
              puts "Return a book"
              member.rendreLivre("Bones to Ashes", biblio)
              puts ""
              puts "To go back press any key....."
              pause = gets
      when 3
        webService
  end
end
