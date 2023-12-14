/*:
 # First Level Error Handling With Optionals
 熟练的开发人员在设计软件时会避免错误。错误处理是优雅地失败的艺术。尽管您完全控制您的代码，但您无法控制外部事件和资源。其中包括用户输入、网络连接、可用系统内存和应用程序需要访问的文件。
 
 在设计应用程序的用户体验时，您必须考虑错误状态。考虑什么可能会出错，您希望应用程序如何响应，以及如何向用户显示该信息以允许他们采取适当的行动。
 
 
 First Level Error Handling With Optionals
 
 Failable Initializers
 
 let value = Int("3")          // Optional(3)
 let failedValue = Int("nope") // nil
 
 enum PetFood: String {
   case kibble, canned
 }

 let morning = PetFood(rawValue: "kibble")  // Optional(.kibble)
 let snack = PetFood(rawValue: "fuuud!")    // nil

 
 

 */


let value = Int("3")
let failedValue = Int("nope")

enum PetFood: String {
  case kibble, canned
}

let morning = PetFood(rawValue: "kibble")
let snack = PetFood(rawValue: "fuuud!")

struct PetHouse {
  let squareFeet: Int
    
  init?(squareFeet: Int) {
    if squareFeet < 1 {
      return nil
    }
    self.squareFeet = squareFeet
  }
}

let tooSmall = PetHouse(squareFeet: 0)
let house = PetHouse(squareFeet: 1)

// Optional chaining
/*
class Pet {
  var breed: String?
    
  init(breed: String? = nil) {
    self.breed = breed
  }
}

class Person {
  let pet: Pet
    
  init(pet: Pet) {
    self.pet = pet
  }
}

let delia = Pet(breed: "pug")
let olive = Pet()

let janie = Person(pet: olive)
// let dogBreed = janie.pet.breed! // This is bad! Will cause a crash!
if let dogBreed = janie.pet.breed {
  print("Olive is a \(dogBreed).")
} else {
  print("Olive's breed is unknown.")
}
*/

class Toy {
    
  enum Kind {
    case ball, zombie, bone, mouse
  }
    
  enum Sound {
    case squeak, bell
  }
    
  let kind: Kind
  let color: String
  var sound: Sound?
    
  init(kind: Kind, color: String, sound: Sound? = nil) {
    self.kind = kind
    self.color = color
    self.sound = sound
  }
}

class Pet {
    
  enum Kind {
    case dog, cat, guineaPig
  }
    
  let name: String
  let kind: Kind
  let favoriteToy: Toy?
    
  init(name: String, kind: Kind, favoriteToy: Toy? = nil) {
    self.name = name
    self.kind = kind
    self.favoriteToy = favoriteToy
  }
}

class Person {
  let pet: Pet?
    
  init(pet: Pet? = nil) {
    self.pet = pet
  }
}

let janie = Person(pet: Pet(name: "Delia", kind: .dog, favoriteToy: Toy(kind: .ball, color: "Purple", sound: .bell)))
let tammy = Person(pet: Pet(name: "Evil Cat Overlord", kind: .cat, favoriteToy: Toy(kind: .mouse, color: "Orange")))
let felipe = Person()

if let sound = janie.pet?.favoriteToy?.sound {
  print("Sound \(sound).")
} else {
  print("No sound.")
}

if let sound = tammy.pet?.favoriteToy?.sound {
  print("Sound \(sound).")
} else {
  print("No sound.")
}

if let sound = felipe.pet?.favoriteToy?.sound {
  print("Sound \(sound).")
} else {
  print("No sound.")
}

// Map and compactMap
let team = [janie, tammy, felipe]
let petNames = team.map { $0.pet?.name }

for pet in petNames {
  // compiler warns you about conversion from Optional to Any
  // print(pet)
  print(pet as Any) // cast to Any to shut the warning off
}


// 更加有用且用户友好的输出：
let betterPetNames = team.compactMap { $0.pet?.name }

for pet in betterPetNames {
  print(pet)
}
