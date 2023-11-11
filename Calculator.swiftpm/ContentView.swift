import SwiftUI
enum Calcfunctions: String {
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case clear = "AC"
    case negative = "+/-"
    case percent = "%"
    case divide = "÷"
    case multiply = "x"
    case subtract = "-"
    case add = "+"
    case zero = "0"
    case decimal = "."
    case equals = "="
    case squareroot = "√"
}
var buttons: [[Calcfunctions]] = [
    [.squareroot, .negative, .percent, .divide],
    [.seven, .eight, .nine, .multiply],
    [.four, .five, .six, .subtract],
    [.one, .two, .three, .add],
    [.clear, .zero, .decimal, .equals]
]
extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
struct ContentView: View {
    
    @State var value: String = "0"
    @State var valuecont = false
    @State var numequation: [Float] = []
    @State var opequation: [String] = []
    @State var decimalcheck: Bool = false
    @State var decimalindex: Int = -1
    @State var negate = false
    func buttoncolor(_ optype: Calcfunctions) -> UIColor {
        switch optype{
            case .zero,.one,.two,.three,.four,.five,.six,.seven,.eight,.nine, .decimal, .clear:
                return .gray
            case .squareroot,.negative,.percent:
                return UIColor(hex: "#c2c2c2FF")!
            case .divide,.multiply,.subtract,.add,.equals:
                return .orange
        }
    }
    func textcolor(_ optype: Calcfunctions) -> Color {
        switch optype{
        case .zero,.one,.two,.three,.four,.five,.six,.seven,.eight,.nine, .decimal,.clear:
                return .white
            case  .squareroot,.negative,.percent:
                return .black
            case .divide,.multiply,.subtract,.add,.equals:
                return .white
        }
    }
    func operations (_ numequation: inout [Float], _ opequation: inout [String],_ op1: String,_ op2: String) -> Float {
        var i=0
        var newnumequation: [Float] = []
        var newopequation: [String] = []
        var currentval: Float = numequation[0]
        for op in opequation {
            if (op == op1 || op == op2) {
                i+=1
                if (op == "/") {
                    currentval = currentval/numequation[i]
                }
                else if (op == "*") {
                    currentval = currentval*numequation[i]
                }
                else if (op == "+") {
                    currentval = currentval+numequation[i]
                }
                else if (op == "-") {
                    currentval = currentval-numequation[i]
                }
            }
            else {
                newopequation.append(op)
                newnumequation.append(currentval)
                i=i+1
                currentval=numequation[i]
            }
        }
        newnumequation.append(currentval)
        numequation=newnumequation
        opequation=newopequation
        return currentval
    }
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text(String(value))
                        .font(.system(size: 100))
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 40, leading: 0, bottom: 0, trailing: 0))
                        .minimumScaleFactor(0.01)

                }
                .padding()
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { item in
                            Button(action: {
                                switch item {
                                    case .zero,.one,.two,.three,.four,.five,.six,.seven,.eight,.nine:
                                        if (decimalcheck == false){
                                            if (valuecont) {
                                                value = "0"
                                                valuecont = false
                                            }
                                            if negate == true {
                                                value = String((Float(value)!*10)-(Float(item.rawValue)!))
                                            }
                                            else if (negate == false){
                                                value = String((Float(value)!*10)+(Float(item.rawValue)!))
                                            }
                                        }
                                        else if (decimalcheck == true){
                                            value = String(Float(value)! + ((Float(item.rawValue)!)*(pow(10,Float(decimalindex)))))
                                            if (Float(item.rawValue) == 0) {
                                                value.append("0")
                                            }
                                            decimalindex -= 1
                                        }
                                    case .clear:
                                        value = "0"
                                        numequation = []
                                        opequation = []
                                        decimalindex = -1
                                        decimalcheck = false
                                        negate = false
                                    case .divide, .multiply, .add, .subtract:
                                        decimalcheck = false
                                        negate = false
                                        decimalindex = -1
                                        numequation.append(Float(value)!)
                                        valuecont = true
                                        if (item == .divide) {
                                            opequation.append("/")
                                        }
                                        if (item == .multiply) {
                                            opequation.append("*")
                                        }
                                        if (item == .add) {
                                            opequation.append("+")
                                        }
                                        if (item == .subtract) {
                                            opequation.append("-")
                                        }
                                    case .percent:
                                        value = String(Float(value)!/100)
                                    case .decimal:
                                        decimalcheck = true
                                    case .equals:
                                        decimalcheck = false
                                        negate = false
                                        decimalindex = -1
                                        numequation.append(Float(value)!)
                                        _ = operations(&numequation, &opequation, "*", "/")
                                        value = String(operations(&numequation, &opequation, "+", "-"))
                                        numequation = []
                                        opequation = []
                                    case .negative:
                                        value = String(-1*Float(value)!)
                                        if (negate == false) {
                                            negate = true
                                        }
                                        else if (negate == true) {
                                            negate = false
                                        }
                                    case.squareroot:
                                        value = String(sqrt(Double(value)!))
                                }
                                if (Float(value)!.isNaN) {
                                    value = "Error"
                                }
                                if(Float(value) == Float(Int(Float(value) ?? 0))) {
                                    value = String(Int(Float(value)!))
                                }
                            }, label: {
                                Text(item.rawValue)
                                    .font(.system(size: 35))
                                    .frame(width: 80, height: 80)
                                    .background(Color.init(buttoncolor(item)))
                                    .foregroundColor(textcolor(item))
                                    .cornerRadius(40)

                            })
                        }
                    }
                    .padding(.bottom, 3)
                }
            }
        }
    }
}
