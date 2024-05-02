import UIKit

// power 1 - 10
// health 10 - 100
protocol Figure {
    var name: String { get }
    var power: Int { get }
    var health: Int { get }
    
    mutating func receiveDamage(with power: Int)
    
    func statsDescription()
}

struct Wolf: Figure {
    var name: String = "Wolf"
    var power: Int = .random(in: 3...5)
    var health: Int = 60
    var bodyColor: String
    
    mutating func receiveDamage(with power: Int) {
        self.health -= power
    }
    
    func statsDescription() {
        print("\(name) stats: (Power: \(power) | Health: \(health))")
    }
}

class Goblin: Figure {
    var name: String
    var power: Int
    var health: Int
    var sneeking: Bool
    
    init(sneeking: Bool) {
        self.name = "Goblin"
        self.power = .random(in: 7...9)
        self.health = 20
        self.sneeking = sneeking
    }
    
    func receiveDamage(with power: Int) {
        self.health -= power
    }
    
    func statsDescription() {
        print("\(name) stats: (Power: \(power) | Health: \(health))")
    }
}

class MiniGoblin: Goblin {
    override init(sneeking: Bool) {
        super.init(sneeking: true)
        
        self.name = "Mini Goblin"
        self.power = 10
        self.health = 10
    }
}

enum Skill: Int, CaseIterable {
    case ShockWave = 12
    case Bleeding = 2
    case GroundBreaking = 10
}

struct Player: Figure {
    var level: Int = 1
    var name: String
    var power: Int
    var health: Int
    var skill: Skill
    
    mutating func receiveDamage(with power: Int) {
        self.health -= power
    }
    
    func statsDescription() {
        print("\(name) stats: (Level: \(level) | Power: \(power) | Health: \(health))")
    }
    
    func damageWithSKillDescription(_ enemies: [Figure], index: Int) {
        print("\(self.name) dealing \(self.power) and skill \(self.skill.rawValue) damage to \(enemies[index].name)")
        print("\(enemies[index].name) actual health: \(enemies[index].health)")
    }
    
    func damageDescription(_ enemies: [Figure], index: Int) {
        print("\(self.name) dealing \(self.power) damage to \(enemies[index].name)")
        print("\(enemies[index].name) actual health: \(enemies[index].health)")
    }
    
    mutating func levelUp() {
        self.level = 2
        self.health = 400
        self.power = .random(in: 10...20)
        print("You just gain new level.")
        statsDescription()
    }
    
}

func getEnemies() -> [Figure] {
    let goblin = Goblin(sneeking: .random())
    let miniGoblin = MiniGoblin(sneeking: true)
    let wolf = Wolf(bodyColor: "Black")
    
    return [goblin, miniGoblin, wolf].shuffled()
}

func enemyDamageDescription(_ player: Player, _ enemies: [Figure], index: Int) {
    print("\(enemies[index].name) dealing \(enemies[index].power) damage to \(player.name)")
    print("\(player.name) actual health: \(player.health)")
}

func gameplay() {
    var player = Player(name: "Tom",
                        power: .random(in: 1...10),
                        health: 200,
                        skill: .GroundBreaking
    )
    var enemies = getEnemies()
    
    for index in enemies.indices {
        print("\(index + 1) FIGHT")
        print(enemies[index].statsDescription())
        print(player.statsDescription())
        print("")
        while player.health > 0 && enemies[index].health > 0 {
            if player.health < 100 && player.health > 90 {
                enemies[index].receiveDamage(with: player.power)
                enemies[index].receiveDamage(with: player.skill.rawValue)
                player.damageWithSKillDescription(enemies, index: index)
                player.receiveDamage(with: enemies[index].power)
                enemyDamageDescription(player, enemies, index: index)
                print("")
            } else {
                enemies[index].receiveDamage(with: player.power)
                player.damageDescription(enemies, index: index)
                player.receiveDamage(with: enemies[index].power)
                enemyDamageDescription(player, enemies, index: index)
                print("")
            }
        }
        print("")
        if player.health <= 0 {
            print("Player is death")
            return
        }
        if enemies[index].health <= 0 {
            print("\(enemies[index].name) is death")
        }
        print("")
        print("------------------------------------")
        print("")
    }
    player.levelUp()
}

gameplay()











