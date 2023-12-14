
//: # Error Protocol

class Pastry {
  let flavor: String
  var numberOnHand: Int
    
  init(flavor: String, numberOnHand: Int) {
    self.flavor = flavor
    self.numberOnHand = numberOnHand
  }
}

enum BakeryError: Error {
  case tooFew(numberOnHand: Int), doNotSell, wrongFlavor
  case inventory, noPower
}

//: # Throwing Errors

class Bakery {
  
  var itemsForSale = [
    "Cookie": Pastry(flavor: "ChocolateChip", numberOnHand: 20),
    "PopTart": Pastry(flavor: "WildBerry", numberOnHand: 13),
    "Donut" : Pastry(flavor: "Sprinkles", numberOnHand: 24),
    "HandPie": Pastry(flavor: "Cherry", numberOnHand: 6)
  ]
  
  func open(_ now: Bool = Bool.random()) throws -> Bool {
    guard now else {
      throw Bool.random() ? BakeryError.inventory : BakeryError.noPower
    }
    return now
  }
    
  func orderPastry(item: String, amountRequested: Int, flavor: String)  throws  -> Int {
    guard let pastry = itemsForSale[item] else {
      throw BakeryError.doNotSell
    }
    guard flavor == pastry.flavor else {
      throw BakeryError.wrongFlavor
    }
    guard amountRequested <= pastry.numberOnHand else {
      throw BakeryError.tooFew(numberOnHand: pastry.numberOnHand)
    }
    pastry.numberOnHand -= amountRequested
        
    return pastry.numberOnHand
  }
}

let bakery = Bakery()

/*
bakery.open()
bakery.orderPastry(item: "Albatross", amountRequested: 1, flavor: "AlbatrossFlavor")
*/
  
do {
  try bakery.open()
  try bakery.orderPastry(item: "Albatross", amountRequested: 1, flavor: "AlbatrossFlavor")
} catch BakeryError.inventory, BakeryError.noPower {
  print("Sorry, the bakery is now closed.")
} catch BakeryError.doNotSell {
  print("Sorry, but we don't sell this item.")
} catch BakeryError.wrongFlavor {
  print("Sorry, but we don't carry this flavor.")
} catch BakeryError.tooFew {
  print("Sorry, we don't have enough items to fulfill your order.")
}

//: 不看详细错误
let open = try? bakery.open(false)
let remaining = try? bakery.orderPastry(item: "Albatross", amountRequested: 1, flavor: "AlbatrossFlavor")

do {
  try bakery.open(true)
  try bakery.orderPastry(item: "Cookie", amountRequested: 1, flavor: "ChocolateChip")
}
catch {
  fatalError()
}

try! bakery.open(true)
try! bakery.orderPastry(item: "Cookie", amountRequested: 1, flavor: "ChocolateChip")

