# Lec4-1

## Introduction of Verilog Programing

좋다, 오늘 강의는 Verilog 프로그래밍의 기본 문법에 관한 것이다.
앞서 말했듯이, Verilog 프로그래밍은 디지털 회로를 물리적으로 구현하기 위한 핵심 기술이다.
우리는 이미 이전 강의의 일부 내용에서 Verilog 프로그래밍을 간단히 언급했지만,
이번 강의에서는 Verilog 프로그래밍의 세부 문법과 디지털 기반 회로를 구현하기 위한 구체적인 기술을 다룰 것이다.

## Combinational & Sequential Logic Circuit
Verilog 프로그래밍 언어를 사용한 디지털 회로 구현을 더 깊게 다루기 전에, 두 가지 용어를 구분하고자 한다.

기존의 CMOS 논리 회로는 두 가지 유형으로 나눌 수 있다. 
첫 번째는 조합 논리 회로(combinational logic circuit)이고, 다른 하나는 순차 논리 회로(sequential logic circuit)이다.

기존의 논리 회로에서 우리는 이미 이 주제를 다룬 적이 있다.

### 조합 논리 회로(combinational logic circuit)
조합 논리 회로는 단순히 `assignment`만으로도 구현할 수 있으며, 이는 수학의 함수와 유사하다.

예를 들어, 함수가 있을 때 그 출력은 현재의 입력 값에만 의존한다.
현재 $x, y, z$ 값이 다르면 출력도 달라진다.
2차 다항식 예시를 생각해보면, 이는 $x$의 함수이며, 매개변수와 연산이 미리 정해져 있다면 최종 출력$y$는 $x$ 값에 따라 달라진다.
$$
y =ax^2+bx+c
$$
이와 같은 현상은 기존의 CMOS 논리 회로에서도 동일하게 나타난다.
예를 들어, 세 개의 입력 A, B, C에 대한 AND 연산을 구현하려 한다면, 출력은 A, B, C의 값에 따라 달라진다.

|A|B|C|Output|
|-|-|-|-|
|0|0|0|0|
|0|0|1|0|
|0|1|0|0|
|0|1|1|0|
|1|0|0|0|
|1|0|1|0|
|1|1|0|0|
|1|1|1|1|

A, B, C의 가능한 조합은 8가지이며, 그에 따라 출력도 다르게 변한다.
즉, 입력 값에 따라 출력이 AND, OR, NOT 게이트의 조합에 의해 결정되는 형태 — 이것이 바로 조합 논리 회로이다.
이는 여러 논리 연산의 조합으로 이루어진 하나의 함수와 같다.

### 순차 논리 회로(sequential logic circuit)

그렇다면 순차 논리 회로는 어떤 것일까?
순차 논리 회로에는 **저장소(storage)** 가 존재한다.
**저장소**의 의미는 "현재 상태를 기억하여 다음 사건에 대비한다"는 것이다.
즉, 이전 상태를 기억하여 현재 출력을 결정한다는 뜻이다.
순차 논리 회로 역시 출력을 만들지만, 그 출력은 **일시적으로 저장소에 저장**되고,
그 저장된 값을 사용하여 이후의 출력을 만들어낸다.

예를 들어, 누산기(accumulator)를 구현한다고 해보자.
이 회로는 입력을 받아 출력을 내보내고, 그 출력을 다시 저장한다.
하지만 단순한 조합 논리 회로에서는 입력 X가 출력 Y에 즉시 영향을 미칠 뿐,
이전 상태를 기억하지 않는다.

따라서 누산기를 만들려면 입력이 '1'일 때 이전 값에 1을 더해야 한다.
한 번 더한 값은 저장되고, 같은 입력(1)을 다시 받으면 최종 출력은 2가 된다.

즉, 이전에 저장된 값을 "기억하여 누적(accumulate)"하는 것이다.
이런 동작에서는 데이터를 기억해야 하며, 이 데이터가 저장소에 저장된다.

따라서 **저장소를 사용하는 회로는 순차 논리 회로**이다.
물론 순차 논리 회로 안에는 조합 논리 회로가 포함될 수도 있다.

예를 들어, 덧셈 연산(addition)은 조합 논리 회로로 구현할 수 있다.
하지만 그 연산 결과는 반드시 **메모리 요소(memory element)** 에 저장되어야 한다.
즉, 순차 논리 회로의 핵심적인 특징은 **메모리 요소를 포함한다는 점**이다.

### Verilog 예문
이제 Verilog 예제를 살펴보자.
```sv
assign out = (sel == 2'b00) ? (a & b) : (sel == 2'b01) ? (a | b) : (a ^ b);
```
여기에서 볼 수 있듯이, 간단한 조합 논리 회로는 **할당문(assignment)** 을 사용하여 구현할 수 있다.
AND 연산이나 XOR 연산을 사용할 수 있으며,
물론 등호(==), 덧셈(+), 곱셈(*) 등의 연산도 가능하다.

하지만 순차 논리 회로의 경우는 어떨까?
```sv
module dff_pos (
    input wire DATA, CLK, CLR,
    output reg Q
);
    always @(posedge CLK, negedge CLR)
        if (CLR == 0) Q = 0;
        else Q = DATA;
endmodule
```
이 경우, 전통적으로 **wire 데이터형**을 사용하여 포트 간의 연결을 정의한다.

그러나 **register(reg)** 타입을 사용할 때는 이것이 **메모리 요소(memory component)** 처럼 동작한다.
이러한 메모리 요소는 **always 문** 안에서 사용할 수 있다.

정리하자면, 조합 논리 회로와 순차 논리 회로의 가장 큰 차이는
**메모리 요소의 사용 여부**이다.
만약 메모리 요소를 사용한다면, 그것은 순차 논리 회로로 분류된다.
이 두 회로의 차이를 설명하는 이유는,
이 개념이 Verilog 프로그래밍 언어를 이해하는 데 있어 매우 중요하기 때문이다.

## Combinational VS Sequential
| 구분         | **Combinational Circuit**                                     | **Sequential Circuit**                                    |
| ---------- | ------------------------------------------------------------- | --------------------------------------------------------- |
| **출력 의존성** | The output depends on input only                              | The output depends on present inputs and past outputs     |
| **메모리 요소** | Memory elements are not required                              | Memory elements are required to store the past outputs    |
| **설계 난이도** | This circuits are easy to design since it contains only gates | Sequential circuits are harder to design                  |
| **속도**     | Combinational circuits are faster in speed                    | Sequential circuits are slower than combinational circuit |
| **예시**     | Parallel Adder, Half Adder                                    | Counter, Register, Flip Flop                              |


## From HDL to Real Hardware

이제 Verilog 프로그래밍 언어를 좀 더 깊게 살펴보자.

하드웨어 기술 언어(HDL)의 구조와, Verilog로 작성한 코드가 실제 물리적 회로로 구현되는 과정을 알아보자.
Verilog 프로그램은 **하드웨어 기술 언어(HDL)** 의 한 형태로 분류된다.
앞서 언급했듯이, Verilog 외에도 **VHDL**, **SystemVerilog** 등이 하드웨어 기술 언어에 속한다.

이러한 언어를 사용해 하드웨어 블록을 기술하면, 그 내용은 **넷리스트(netlist)** 로 변환된다.
이 변환 과정을 **합성(synthesis)** 이라고 부른다.
즉, HDL 코드를 작성하면, 컴퓨터가 해당 코드를 분석하여 논리 게이트의 정의와 연결 관계를 포함한 **netlist**로 변환한다.
```
G1 "AND" N1 N2 N5
G2 "AND" N3 N4 N5
G3 "OR" N5 N6 N7
```
예를 들어, G1이 AND 게이트라고 하면, 입력 간의 AND 연산을 정의하고 그 출력이 M5로 전달되는 식으로 구성된다.
이러한 정의들이 모여 하나의 넷리스트를 형성한다.
합성 과정을 거치면, Verilog 프로그램은 논리 게이트들과 그 연결 정보를 포함한 **netlist**로 변환된다.
그 후, 이 넷리스트는 **PNR (Place and Route, 배치 및 배선)** 과정을 통해 실제 물리적 회로 레이아웃으로 전환된다.
이 "Place and Route"라는 용어는 주로 **ASIC 설계**에서 사용된다.

하지만 **FPGA** 구현의 경우, Verilog로 작성된 논리 함수는 **프로그래머블 하드웨어 블록에 매핑(mapping)** 된다.
이 점이 ASIC과 FPGA 설계의 주요 차이점이다.
ASIC 설계에서는 표준 셀(standard cell)을 적절한 위치에 배치하고, 넷리스트로부터 얻은 연결 정보를 기반으로 배선을 정의한다.
따라서 디지털 회로를 구현하기 위해서는 **합성과 PNR 과정**을 반드시 거쳐야 하지만,
그 첫 단계는 언제나 **Verilog 프로그램을 작성하는 것**이다.

## Verilog: Defining Modules and their Connections

자, Verilog의 정의는 **모듈(module)** 과 그 **연결(connection)** 을 기술하는 것이다.

Verilog 설계의 기본 단위는 바로 모듈의 정의이다.
이는 C나 Python에서 함수를 정의하는 것과는 매우 다르다.
C나 Python에서 함수(function)는 말 그대로 "함수"이며,
입력값과 내부 변수(혹은 메모리)를 이용해 특정 연산을 수행하고 결과를 반환한다.

하지만 Verilog의 **모듈(module)** 은 함수와 다르다.
함수가 "무엇을 할 것인가(행동)"를 정의한다면,
모듈은 "무엇이 존재하는가(구조)"를 정의한다.
즉, 모듈은 동작이 아닌 **하드웨어의 구성과 연결 관계를 기술**하는 것이다.

하드웨어 구조를 보면 "이 회로는 이런 기능을 하겠구나" 하고 추측할 수는 있지만,
그 기능 자체를 직접 정의하지는 않는다.
따라서 Verilog 설계는 **모듈을 정의하고**,
이 모듈들 간의 **연결 관계(interconnection)** 를 정의하는 것이라고 할 수 있다.

모듈(module)은 하나의 단일 구성요소일 수도 있고,
여러 개의 하위 설계 블록(low-level design block)들을 모은 집합일 수도 있다.
즉, 모듈 내부에는 또 다른 여러 모듈들을 **인스턴스화(instantiation)** 할 수 있다.

기본적으로 모듈은 하드웨어의 **기본 단위 블록**으로,
각 구성요소의 위치(placement)와 이들을 연결하는 **배선(wire)** 을 정의한다.

### 2 to 1 MUX 예시

예를 들어 간단한 회로 예시를 보자.

이 회로는 **멀티플렉서(Multiplexer, MUX)** 를 나타낸다.
선택 신호(selection)가 `0`이면 출력은 **a**,
선택 신호가 `1`이면 출력은 **b**가 된다.
이것이 멀티플렉서의 기본 동작이다.
이 회로를 구현하기 위한 논리 연산은 다음과 같다.

- `sel = 1` -> `out` = `a`
- `sel = 0` -> `out` = `b`

$$
\mathrm{Out}=\mathrm{Sel}\cdot\mathrm{a}+\bar{\mathrm{Sel}}\cdot\mathrm{b}
$$

즉, 출력은 두 입력 중 하나를 선택하는 논리로 표현된다.
이 기능은 Verilog의 할당문(assignment)을 이용해 간단히 구현할 수 있다.
각 포트의 의미에 대해서는 나중에 자세히 설명하겠지만,
직관적으로 보면 선택 신호가 `1`일 때 A가 출력되고,
`0`일 때는 B가 출력되는 구조임을 알 수 있다.
이것이 멀티플렉서 표기의 의미이다.

이제 이 기능을 구현하고자 한다면, 출력의 보수(output bar)도 정의할 수 있다.
여기서 'bar'는 출력을 **논리 부정(NOT)** 한 결과를 의미하므로,
출력에 NOT 연산을 적용하면 **output bar**를 쉽게 얻을 수 있다.

#### Code - 직관적인 방식
```sv
module mux_2_to_1(a, b, out, outbar, sel);
// This is 2:1 MUX
    input a, b, sel;
    output out, outbar;

    assign out = sel ? a : b;
    assign outbar = ~out;

endmodule
```
이것이 Verilog에서의 **모듈 정의(module definition)** 의 기본 형태이다.

앞서 언급했듯이, Verilog에서 모듈을 정의할 때는
`module` 키워드로 시작하고 `endmodule`로 끝난다.
모듈 이름은 `module` 키워드 뒤에 작성하며, 그 다음에
모듈의 **입출력 포트(port)** 를 정의해야 한다.

포트 정의 방식에는 여러 형태가 있으며,
여기 제시된 방법 외에도 이후 강의에서 다른 표기 방식들을 다룰 것이다.
포트 이름을 정의한 후에는,
**할당문(assign)** 을 이용하여 CMOS 기반 논리 회로의 동작을 기술하거나,
**always 문**을 이용하여 메모리 요소가 포함된 동작을 기술할 수 있다.
즉, 이런 종류의 기능을 구현하기 위해서는 반드시 모듈을 정의해야 한다.

그리고 중요한 점은 —
Verilog 코드를 해석하거나 번역할 때,
이를 일반 프로그래밍 언어처럼 "입력을 받아 순차적으로 처리하는 코드"로 이해하면 안 된다.
Verilog는 **하드웨어 그 자체를 기술하는 언어**이다.
즉, 코드의 의미는 "어떤 논리 게이트들이 어떤 방식으로 연결되어 있는가"를 표현하는 것이며,
절차적 명령 수행을 나타내는 것이 아니다.

#### Code 분석

이 코드를 단계적으로 분석해보자.
이 하드웨어는 **`mux_2_to_1`**이라는 이름의 멀티플렉서(multiplexer)이다.
이 모듈에는 **다섯 개의 포트(port)** 가 있다:

- `a`
- `b`
- `out`
- `outbar`
- `sel`

즉, 총 다섯 개의 포트로 구성되어 있다.

여기서 `a`, `b`, `sel`은 **입력(input)** 이고,
`out`과 `outbar`는 **출력(output)** 이다.

이 다섯 포트가 존재하지만,
이들을 연결하는 **통신 채널(배선, wire)** 은
상위 모듈에서 인스턴스화될 때 **모듈 외부에서 연결**된다.

이 회로 내부를 살펴보면,
입력 `a`와 `b`를 받아 선택 신호 `sel`에 따라 출력을 생성한다는 것을 알 수 있다.

즉, 이 회로는 선택선에 따라 `a` 또는 `b` 중 하나를 출력하는 **멀티플렉싱 연산**을 수행한다.

또한 `outbar`는 출력의 **논리 부정(NOT)** 결과이므로,
출력에 NOT 게이트가 연결되어 생성된다.
따라서 이 모듈의 정의는 **함수(function)의 정의**와 다르다.

이것은 "하드웨어의 구조와 연결 관계를 기술한 것"이다.
즉, 하드웨어 모듈을 설계할 때는
가장 먼저 **논리 연산을 기반으로 한 하드웨어의 구성과 연결 구조**를 정의해야 한다는 점을 기억해야 한다.

#### 하드웨어 설계 후 과정

Verilog 언어를 사용해 하드웨어를 설계한 후에는,
이를 **합성(synthesis)** 과정을 통해 **넷리스트(netlist)** 로 변환한다.
FPGA 구현의 경우, 이 합성 과정은 흔히 **컴파일(compile)** 과정이라고 부른다.

컴파일이 완료되면 Verilog 프로그램은 **FPGA 내부의 프로그래머블 블록**으로 매핑된다.
앞서 언급했듯이, Verilog는 **AND**, **OR**, **NOT** 등의 단순한 논리 연산자를 사용한다.
이들은 각각 `&`, `|`, `~` 와 같은 기호로 표현된다.

또한 **NAND**, **NOR**, **XOR** 등의 연산이나 `+`, `-` 같은 산술 연산자도 사용할 수 있다.
하지만 이러한 **원시적(primitive)** 연산자들을 직접 코딩하는 방식은 오늘날 자주 사용되지 않는다.

왜냐하면 이러한 연산 블록들은 이미 **기본 블록(basic block)** 으로 라이브러리에 정의되어 있기 때문이다.

물론 직접 사용할 수도 있지만, 대부분의 설계자는
코드를 보다 간결하고 직관적으로 만들기 위해 **기호(symbolic operator)** 를 사용하는 방식을 선호한다.

#### Code - 게이트 단위(primitive)

만약 Verilog 프로그램을 **게이트 단위(primitive)** 로 설계한다면,
모듈 정의는 다음과 같은 형태가 될 것이다.
```sv
module mux_2_to_1(a, b, out, outbar, sel);
    input a, b, sel;
    output out, outbar;
    wire out1, out2, selb;
    and a1 (out1, a, sel);
    not il (selb, sel);
    and a2 (out2, b, selb);
    or o1 (out, out1, out2);
    assign outbar = ~out;
endmodule
```
이는 앞 슬라이드에서 본 코드와 **동일한 기능**을 수행한다.
두 코드 모두 같은 기능 블록을 구현하지만,
**기본 논리 게이트(primitive gate)** 들을 직접 사용하는 경우,
모듈의 전체적인 동작을 파악하기가 매우 어렵다.
특히 여러 명의 프로그래머가 함께 하드웨어 설계를 진행할 때,
이러한 게이트 수준 설계는 코드의 **가독성과 유지보수성**을 크게 떨어뜨린다.

따라서 **게이트 수준 설계보다는**,
이와 같은 **행위적(behavioral)** 또는 **구조적(structural)** 스타일의 Verilog 코드를 사용하는 것을 권장한다.
이 방식은 훨씬 더 직관적이다.
선택 신호(`sel`)의 값에 따라 출력이 A 또는 B로 결정되고,
`out_bar`는 그 출력을 단순히 NOT 연산한 값이 된다.
즉, 가능한 한 **게이트 직접 정의보다는 고수준 프로그래밍 스타일**을 사용하는 것이 좋다.

## Synthesis for FPGA or ASIC

Verilog 프로그램을 작성한 후에는 **합성(synthesis)** 과정을 거치게 된다.

### FPGA
FPGA 설계에서는 이 과정에서 **매크로(macros)** 가 추론된다.
*(Built-in 이다)*
이는 Verilog 코드가 자동으로 **내장된 기능 블록(LUT, 멀티플렉서, 플립플롭 등)** 에 매핑된다는 뜻이다.
하지만 **FPGA는 ASIC에 비해 하드웨어 자원이 낭비되는 경향이 있다.**

그 이유는, FPGA는 이미 존재하는 블록 중에서 필요한 블록만 선택하여 설정할 뿐,
사용되지 않는 블록들은 회로 내에 그대로 남아 있기 때문이다.

### ASIC
반면 **ASIC(Application-Specific Integrated Circuit)** 설계에서는
필요하지 않은 논리 회로를 완전히 제거하고,
**필요한 블록만을 물리적으로 구현**한다.
따라서 ASIC은 **전력 효율이 훨씬 높다.**

하지만 한 번 **ASIC이 제조사(foundry)** 에 의해 제작되면,
그 안의 하드웨어 논리 게이트는 더 이상 수정할 수 없다.
반면 FPGA는 **제작 이후에도 하드웨어 구성을 다시 프로그래밍할 수 있다.**

즉, FPGA는 "프로그래머블 하드웨어(Programmable Hardware)"라는 점에서 유연성을 가진다.
어쨌든, 합성(synthesis) 또는 컴파일(compile) 과정을 수행할 때,
FPGA 설계에서는 도구가 **FPGA 매크로(macros)** 를 선택하고,
ASIC 설계에서는 **표준 셀(standard cell)** 을 선택하여 대상 칩에 통합한다.
이러한 선택 과정이 바로 **합성(synthesis)** 이며,
FPGA의 경우에는 이를 **컴파일(compilation)** 이라고 부르기도 한다.

합성 또는 컴파일 이후에는 **매핑(mapping)** 단계가 이어진다.
이 단계에서는 각 FPGA 매크로나 ASIC 표준 셀이 **어디에 배치될지**,
그리고 **배선(routing)** 으로 인한 지연 시간을 어떻게 최소화할지를 결정한다.
이 과정을 **Place and Route (PNR)** 라고 한다.
PNR 단계에서는 각 셀이나 매크로의 **물리적 위치**를 배치하고,
이들 간의 **연결선(wiring)** 을 정의한다.

## Introduction to Verilog HDL

이제 우리는 하드웨어 기술 언어(HDL), 특히 **Verilog** 가 매우 중요하다는 것을 이해했다.
Verilog로 하드웨어를 설계하면,
그 코드는 **합성(synthesis)** 과 **배치·배선(Place and Route, PNR)** 과정을 거쳐
**물리적인 회로(physical implementation)** 로 변환된다.

이번 강의에서는 Verilog 하드웨어 기술 언어의 **기본 문법(grammar)** 을 다루고 있다.
물론 **VHDL**이나 **SystemVerilog** 같은 다른 HDL도 존재하지만,
Verilog는 여전히 **디지털 회로 설계에서 가장 대표적이고 널리 사용되는 언어**이다.

물론 Verilog에도 나름의 역사적 배경이 있지만,
현재 우리의 학습 목적에서는 그다지 중요하지 않다.
더 중요한 것은, **하드웨어 기술 언어(HDL)** 가
여러 **추상화 단계(level of abstraction)** 를 제공한다는 점이다.

예를 들어, Verilog는 **RTL(Register Transfer Level)** 설계를 지원하며,
이는 레지스터 간의 데이터 이동을 기술하는 수준이다.
또한 **혼합 수준 모델링(mixed-level modeling)** 과 **시뮬레이션(simulation)** 도 가능하다.
즉, **행위적(behavioral)**, **구조적(structural)**, **게이트 수준(gate-level)** 설계를 함께 사용할 수 있다.
보통 Verilog에서는 **상위 모듈(high-level module)** 을 정의한 후,
이를 **테스트벤치(testbench)** 를 이용해 기능적으로 시뮬레이션하여 검증한다.

### 4 value logic (0, 1, x, z)

어쨌든, Verilog 프로그래밍에서 가장 중요한 점 중 하나는
논리 값이 **4가지 상태(0, 1, X, Z)** 로 표현된다는 것이다.

`0`과 `1`은 쉽게 이해할 수 있다.

- `0`은 **접지(GND, 0 V)**,
- `1`은 **높은 전압(VDD)** 을 의미한다.

하지만 `X`와 `Z`는 조금 다르다.

- `X` : 알 수 없는 상태(unknown) — 실제 전압이나 논리값을 확정할 수 없음
- `Z` : 부유 상태(floating, high impedance) — 어떤 회로에도 연결되지 않음

이 개념을 그림으로 다시 생각해보자.

출력 노드가 포트 **A**와 **B**에 연결되어 있다고 하자.
- A는 GND와 연결
- B는 VDD와 연결
- A가 높은 전압(high), B가 낮은 전압(low)이면 -> 출력은 `0` (GND)
- B가 높은 전압(high), A가 낮은 전압(low)이면 -> 출력은 `1` (VDD)


#### X - 둘다 높은 전압이라면?

그런데 만약 A와 B가 **둘 다 높은 전압을 동시에 출력하려 한다면**,
하나는 `0`, 다른 하나는 `1`을 출력하려 하므로 두 신호가 **충돌(conflict)** 하게 된다.
이 경우 정확한 값을 예측할 수 없다.

만약 두 신호의 구동 능력이 동일하다면, 출력은 약 **0.5 V** 근처에서 정지할 수도 있다.
하지만 보통은 강도 차이가 약간 있기 때문에,
결과적으로 `0`이나 `1` 쪽으로 치우치게 된다.

그러나 그 값은 **정의할 수 없으므로 `X`(unknown)** 상태로 표현한다.

#### Z - 둘다 낮은 전압이라면?

또한 A와 B가 모두 **꺼져(off)** 있는 경우,
즉 회로가 출력 노드를 **구동하지 않는다면**,
출력은 **부유 상태(Z)** 가 된다.

이때 전압은 이전 값에 따라 달라질 수 있다.
예전에 1 V였다면 누설전류로 인해 조금씩 감소할 것이고,
0 V였다면 그대로 유지될 수도 있다.

어쨌든 외부에서 구동하는 회로가 없으므로,

전압이 자유롭게 변할 수 있는 상태이다 — 이것이 바로 **고임피던스(floating, Z)** 상태다.

정리하자면,

| 논리 값 | 의미 | 상태 설명 |
| --- | --- | --- |
| `0` | GND | 낮은 전압 |
| `1` | VDD | 높은 전압 |
| `X` | Unknown | 충돌 또는 정의 불가 |
| `Z` | High Impedance | 외부 구동 없음, 부유 상태 |

즉, `Z` 상태는 "어떤 소자에도 구동되지 않은 상태"를 뜻하며,
이후 신호가 연결되면 전압은 다시 변할 수 있다.
이 개념은 이후 강의에서 다시 다루게 될 것이다.

## Module & Hierarchy Example - Low-level Module

이제 Verilog 기반 프로그래밍에 대한 간단한 소개를 살펴보자.
앞서 언급했듯이, Verilog 프로그램은 항상 **모듈(module)** 정의에서 시작한다.

모듈은 **계층적(hierarchical)** 으로 정의될 수도 있다.
즉, 하나의 모듈 안에 다른 하위 모듈(submodule)을 포함시킬 수 있다.
모듈을 정의할 때는 반드시 **`module`** 키워드로 시작하고 **`endmodule`** 로 끝나야 한다.

그 사이에 **모듈 이름**을 명시하고,
하드웨어의 **입출력 포트(input/output port)** 를 정의해야 한다.

이러한 포트 정의 방식은 작성 스타일에 따라 약간 다르다.

```sv
module dEdgeFF (
    output reg q,
    input wire clock, data
);
    always @(negedge clock)
        #10 q = data;
endmodule
```
일부 스타일에서는 모듈 이름을 먼저 선언한 뒤,
그 아래에서 각 포트가 입력인지 출력인지를 따로 정의한다.

```sv
module m555(
    output reg clock
);
    initial 
        #5 clock = 1;
    always
        #50 clock ~clock;
endmodule
```
반면 다른 스타일에서는 포트의 **형태(input/output)** 와 **이름(name)** 을
같은 줄에서 함께 정의한다.

두 방식 모두 유효하지만,
일반적으로 **형태와 이름을 동시에 정의하는 방식**이 코드의 가독성이 더 높다.

포트를 정의할 때는 각 포트가 **`input`**, **`output`**, 혹은 **`inout`** 인지를 명시해야 한다.
또한 각 포트의 **데이터 타입(data type)** 도 지정해야 한다.

앞선 예제에서는 데이터 타입이 명시되지 않았는데,
이는 기본적으로 모든 포트가 **`wire`** 타입으로 설정된다는 뜻이다.
예를 들어, `clock`과 `data` 포트는 `wire` 타입으로 정의되고,
`q` 포트는 **`reg` (register)** 타입으로 정의될 수 있다.

기본적으로 내부 신호(internal port)는 `wire` 타입이지만,
값을 **저장해야 하는 신호**라면 `reg` 타입으로 선언해야 한다.
이때는 신호 이름 앞에 `reg` 키워드를 붙인다.
단, **입력 포트(`input`)는 `reg` 타입으로 선언할 수 없다.**

입력은 외부 모듈로부터 데이터를 **수신**하는 역할만 하므로,
항상 `wire` 타입으로 간주된다.
반면 **`reg` 타입**은 모듈 내부에서 값을 **저장하거나 유지**하기 위한 데이터형으로,
그 동작은 보통 **`always` 블록** 내에서 정의된다.

이러한 기능 블록에서는 일반적으로 **할당문(`assign`)** 을 사용하여 동작을 기술하지만,
이번 예제처럼 **`reg` 타입 신호의 값을 변경해야 할 경우**,
**`always` 문**을 사용해야 한다.

여기서 사용하는 **클록(clock)** 신호는 주기적으로 변화하는 신호이며,
시간 영역(time domain)에서 보면 **고(High)와 저(Low)** 가 번갈아 나타나는 **사각파 형태**이다.
클록의 **하강 에지(negative edge)** 에서 트리거되도록 정의한다면,
이는 "클록이 **High -> Low** 로 전환될 때마다 동작을 수행한다"는 의미이다.

예를 들어, 다음과 같은 동작을 생각해보자.
클록의 하강 에지가 발생할 때마다,
출력 `q`는 현재 입력 `data`의 값을 저장한다.
- 첫 번째 하강 에지 시: `data = 0` -> `q = 0`
- 두 번째 하강 에지 시: `data = 1` -> `q = 1`
즉, 매번 하강 에지가 감지될 때마다 `data`의 값이 `q`로 전달되어 저장된다.

또한, 출력이 변경되기 전에 **일정한 지연(delay)** (예: `#10`)이 있을 수 있는데,
이 **지연 요소(delay component)** 에 대해서는 이후에 자세히 다룰 예정이다.

### dEdgeFF & m555 - 예시 모듈

이제 두 개의 예시 모듈을 살펴보자 — **모듈 1(Module 1)** 과 **모듈 2(Module 2)** 이다.

```sv
module dEdgeFF (
    output reg q,
    input wire clock, data
);
    always @(negedge clock)
        #10 q = data;
endmodule
```
먼저 **모듈 1**에서는 두 개의 입력 포트 `clock`, `data` 와 하나의 출력 포트 `q`가 정의되어 있다.
이 모듈은 **D 플립플롭(D flip-flop)** 의 기능을 수행한다.
즉, 클록 신호의 특정 에지(상승 또는 하강)에서 입력 `data`의 값을 출력 `q`에 저장한다.

다음은 **모듈 2**이다.
```sv
module m555(
    output reg clock
);
    initial 
        #5 clock = 1;
    always
        #50 clock ~clock;
endmodule
```
이 모듈 역시 `module`로 시작하고 `endmodule`로 끝난다.
출력 포트는 단 하나, `clock`이며 `reg` 타입으로 선언되어 있다.

입력 포트는 존재하지 않는다.
일반적으로 **`initial` 문**을 이용해 모듈 동작을 정의하는 것은 권장되지 않지만,

이 예제에서는 **간단한 클록 생성기(clock generator)** 를 설명하기 위해 사용한다.
이 경우, 출력 `clock`은 **15ns마다 반전(toggle)** 된다.

즉, 처음에 `0`이었다면 15ns 후 `1`로 바뀌고,

다시 15ns 후에는 `0`으로 돌아간다.
이렇게 반복되어 **주기 30ns의 사각파(clock signal)** 가 생성된다.

물론 이 시간 단위(15ns, 50µs 등)는 Verilog 코드나 테스트벤치에 설정된 **timescale 지시문**에 따라 달라질 수 있다.
이러한 클록 생성 모듈의 이름은 **`m555`** 이며, 정의가 끝나면 `endmodule`로 종료된다.

정리하자면, Verilog에서 모듈을 정의할 때는 다음과 같은 순서를 따른다.

1. **`module`** 키워드로 시작하고 **모듈 이름(module name)** 을 지정한다.
2. 모듈에서 사용할 **입력(input)**, **출력(output)**, 또는 **양방향(inout)** 포트를 정의한다.
3. 포트를 정의한 후, 모듈 내부의 **논리 회로(logic)** 를 기술한다.
    - 순차 논리 회로(sequential logic): 플립플롭, 레지스터 등을 포함.
    - 조합 논리 회로(combinational logic): 논리 게이트나 할당문을 이용해 구현.
4. 마지막으로 **`endmodule`** 키워드로 모듈 정의를 종료한다.


## Module & Hierarchy Example - high-level Module

이제 이전에 정의한 두 개의 모듈을 사용하여
상위 모듈(**higher-level module**)을 설계해보자.

이 새로운 모듈의 이름은 **`m16`** 이며,
이 안에는 앞서 만든 **엣지 트리거 플립플롭(edge-triggered flip-flop)** 이 포함된다.


이제 실제로 **`m16` 모듈**을 설계해보자.
```sv
module m16 (
    output wire [3:0] value,
    input wire clock,
    output wire fifteen, altFifteen
);
    dEdgeFF a(value[0], clock, ~value[0]),
            b(value[1], clock, value[1]^value[0]),
            c(value[2], clock, value[2]^&value[1:0]),
            d(value[3], clock, value[3]^&value[2:0]);
    
    assign fifteen = value[0] & value[1] & value[2] & value[3];
    assign altfifteen &value;
endmodule
```
항상 그렇듯이, 먼저 **모듈 이름(module name)** 을 지정하고
**입출력 포트(input/output ports)** 를 정의해야 한다.

그 다음, 이전에 만든 모듈(예: 플립플롭)을
**인스턴스화(module instantiation)** 하여 내부에 포함시킨다.
이 과정을 통해 여러 하위 모듈들이 연결되어 하나의 기능을 수행하게 된다.

마지막으로, 모듈 정의의 끝에는 **`endmodule`** 를 반드시 작성한다.
이제 `m16` 모듈의 하드웨어 구성을 살펴보면 다음과 같다.

- 입력 포트: `clock`
- 4개의 D 플립플롭 인스턴스: `a`, `b`, `c`, `d`
- 출력: `value[3:0]` (4비트 와이어 버스)
- 추가 출력: `fifteen`, `altfifteen`(논리 연산으로 생성된 특수 신호)

앞서 언급했듯이, D 플립플롭(D flip-flop) 블록은 두 개의 입력을 가진다:
`clock` 과 `data` 이다.
이 입력의 순서는 반드시 유지되어야 하며, **클록이 먼저**, **데이터가 그 다음**이다.

`m16` 설계에서 플립플롭 **a**, **b**,  **c**, **d**는 모두 동일한 **클록 신호**를 입력받는다.
하지만 각 플립플롭의 **데이터 입력(data input)** 은 서로 다른 논리 연산 결과로 구성된다.

예를 들어:

- **a**의 입력은 **인버터(inverter)** 를 통해 반전된 신호(`~value0`)가 연결된다.
- **b**의 입력은 `value0`과 `value1`의 **XOR 연산 결과**이다.
- **c**의 입력은 이전 단계의 출력들을 이용한 또 다른 **XOR 결과**이다.
- **d**의 입력은 `value0`, `value1`, `value2`, `value3`의 **AND 연산 결과**로 구성될 수 있다.

따라서 `F15`와 `R15`는 이러한 4비트 신호들의 **논리 조합(AND, XOR 등)** 으로 표현될 수 있으며,
결과적으로 동일한 논리적 출력을 생성한다.

이 슬라이드에서 강조하고자 하는 핵심은,
**하드웨어 기술 언어(HDL)** 는 어떤 "절차"나 "명령"을 기술하는 언어가 아니라,
**회로의 구조(components and connections)** 그 자체를 기술하는 언어라는 점이다.

Verilog 기반 설계를 다룰 때는,
코드로 표현된 **하드웨어 블록 다이어그램(hardware block diagram)** 을 해석하는 방법을 이해해야 한다.

## Module & Hierarchy Example - Testbench

하드웨어 모듈을 정의한 후에는, 이를 검증하기 위한 **테스트벤치(testbench)** 를 작성해야 한다.
테스트벤치는 설계의 동작을 확인하는 용도로 사용되는 **최상위 모듈(top-level module)** 이다.
따라서 **입출력 포트(input/output port)** 를 정의할 필요가 없다.

```sv
module board();
    wire [3:0] count;
    wire clock, f, af;

    m16 counter(count, clock, f, af);
    m555 clockGen(clock);

    always @ (posedge clock)
        $display($time, "count=%d, f=%d,af=%d", count, f, af);
endmodule
```

그 대신, 내부에서 이미 정의된 하위 모듈들을 인스턴스화하여 연결한다.
물론 테스트벤치도 하나의 Verilog 모듈이므로,
다른 모듈과 마찬가지로 `module`로 시작하고 `endmodule`로 끝나야 한다.
테스트벤치 내부에서는 다음과 같은 내부 신호를 정의할 수 있다.

```sv
wire [3:0] count;
wire clock, f, af;
```

이 예시에서는 **`m16` 카운터 모듈**을 테스트벤치 안에서 인스턴스화한다.
```sv
m16 counter(count, clock, f, af);
m555 clockGen(clock);
```
이미 정의된 `m16`의 내부 논리를 다시 작성할 필요는 없으며,
**포트 연결(port mapping)** 만 올바르게 수행하면 된다.

예를 들어:
- `clock` 신호는 테스트벤치에서 생성되어 `m16`의 입력으로 전달된다.
- `f`, `af`, `value` 신호는 `m16`의 출력으로 연결된다.
- `value`는 4비트 와이어(`wire [3:0]`)로, 카운터의 출력을 나타낸다.

또한, `m16`의 입력 클록은 이전에 정의한 **`m555` 클록 생성기 모듈**의 출력을 사용한다.
즉, `m555` 모듈의 출력이 `m16`의 클록 입력으로 연결되어 전체 회로가 동작하게 된다.

앞서 언급했듯이, `value` 신호는 회로의 **출력(output)** 을 나타낸다.
```sv
always @ (posedge clock)
    $display($time, "count=%d, f=%d,af=%d", count, f, af);
```
클록의 **상승 에지(positive edge)** 가 발생할 때,
회로는 그 이벤트를 감지하고 출력을 갱신한다.

즉, 매번 상승 에지가 감지될 때마다 **카운터 값(counter value)** 이 갱신되어
터미널(또는 시뮬레이터 로그)에 출력된다.
이를 통해 클록이 한 번씩 증가할 때마다 카운터의 동작을 직접 관찰할 수 있다.
출력값은 회로의 논리에 따라 `15` 또는 그 보수(`~15`)가 될 수 있다.

이 과정을 통해 시뮬레이터는 각 클록 상승 에지에서 어떤 출력이 발생했는지를 보여준다.

이 부분에서 가장 중요한 점은 다음과 같다
- 하드웨어의 동작은 **모듈 정의(module definition)** 를 통해 기술한다.
- 각 모듈은 반드시 `module` 로 시작하고 `endmodule` 로 끝나야 한다.
- 모듈 내부에는 **순차 논리(sequential logic)** 또는 **조합 논리(combinational logic)** 를 포함한다.
- 이들을 조합하여 전체 회로의 동작이 완성된다.

정의한 모듈은 이처럼 **상위 모듈(higher-level module)** 내에서 인스턴스화(instantiation)하여 사용할 수 있다.
예를 들어, `DH`라는 이름의 모듈을 정의했다고 하자.

이 모듈을 사용할 때는 반드시 **인스턴스 이름(instance name)** 을 지정해야 하며,
상위 모듈에서 연결할 때는 **포트 순서(port order)** 를 올바르게 유지해야 한다.

또한, 모듈 인스턴스 외에도
상위 모듈 내부에 **조합 논리 회로(combinational logic)** 를 추가로 정의할 수 있다.
이를 위해 **`assign` 문**이나 **`always` 문**을 사용할 수 있다.

모든 하위 모듈을 정의한 후에는
이를 **테스트벤치(testbench)** 안에 인스턴스화하여 전체 회로의 동작을 검증할 수 있다.
테스트벤치는 앞서 언급했듯이 **입출력 포트**를 가지지 않으며,

대신 **모듈 인스턴스화(module instantiation)** 와
**순차적 시뮬레이션(initial, always 블록)** 을 통해
시간에 따른 신호의 변화를 모의한다.

표면적으로 보면, 테스트벤치의 코드는
**C**나 **Python** 같은 순차적 언어와 유사하게 보일 수 있다.
왜냐하면 `initial` 블록 내의 문장들이 순서대로 실행되기 때문이다.

하지만 Verilog는 근본적으로 **병렬(parallel)** 하드웨어 기술 언어이다.
각 하드웨어 블록은 **동시에(concurrently)** 작동하며,
입력을 관찰하고 출력을 동시에 갱신한다.
즉, Verilog 프로그램은 **한 줄씩 순차적으로 실행되는 것이 아니라**,

**하드웨어 전체가 병렬적으로 동작하는 방식**으로 처리된다.

## Module Definition

앞서 언급했듯이, Verilog 프로그램은 항상 **모듈 정의(module definition)** 부터 시작한다.
모듈 정의는 **`module`** 키워드로 시작하고 **`endmodule`** 로 끝난다.

`module` 뒤에는 **모듈 이름(module name)** 을 명시해야 한다.
그 다음, 각 포트를 **입력(`input`)**, **출력(`output`)**, 또는 **양방향(`inout`)** 으로 정의한다.

만약 데이터 타입을 명시하지 않으면,
그 포트는 **기본적으로 `wire` 타입**으로 간주된다.

예를 들어, 간단한 모듈 정의는 다음과 같은 구조를 가진다.
```sv
module module_name(
    input in1,
    input in2,
    output out,
    ...
);

endmodule
```
`module` 선언 후 포트 리스트를 정의하고,
마지막에 `endmodule`로 모듈 정의를 종료한다.


```sv
module pe_single_batch #(
    parameter W_SLICE   = 4,
    parameter I_WIDTH   = 8,
    parameter I_CH      = 1024,
    parameter ACC_WIDTH = $clog2(I_CH),
    parameter M_WIDTH   = W_SLICE + I_WIDTH,
    parameter O_WIDTH   = W_SLICE + I_WIDTH + ACC_WIDTH,
    parameter O_CH      = 32
)(
    input  wire                   i_clk,
    input  wire                   i_rstn,
    // act_controller
    // input wire [O_CH-1:0]      ipred,
    input  wire                   i_en,
    input  wire                   i_first,
    input  wire [I_WIDTH-1:0]     i_ia,
    input  wire [W_SLICE-1:0]     i_w   [0:O_CH-1],

    output wire [O_WIDTH-1:0]     o_out [0:O_CH-1]
);

    //============================================================
    // Signal Declarations
    //============================================================
    genvar och;

    reg  [O_WIDTH-1:0] acc_out_reg [0:O_CH-1];
    wire [M_WIDTH-1:0] mult_out    [0:O_CH-1];
    wire [O_WIDTH-1:0] acc_in      [0:O_CH-1];
    wire [O_WIDTH-1:0] acc_out     [0:O_CH-1];
    wire [W_SLICE-1:0] mult_in_w   [0:O_CH-1];

    //============================================================
    // Assignments
    //============================================================
    generate
        for (och = 0; och < O_CH; och = och + 1) begin
            assign o_out[och]     = acc_out_reg[och];
            assign mult_in_w[och] = i_w[och];
            assign acc_in[och]    = {O_WIDTH{i_first}} & acc_out_reg[och];
        end
    endgenerate
endmodule

```
예시로 `psingle_batch`라는 이름의 모듈을 정의한다고 하면,
그 안에는 다음과 같은 내용이 포함된다.
- 각 포트가 **입력(input)** 인지 **출력(output)** 인지 명시하고,
- 신호 타입이 **`wire`** 인지 **`reg`** 인지를 지정한다.
포트 정의가 끝나면 반드시 **세미콜론(`;`)으로 마무리**해야 하며,
각 포트 이름은 **쉼표(,)** 로 구분한다.
이후 다른 회로에서 해당 모듈을 사용할 때는,
**모듈 이름(module name)** 과 함께 **인스턴스 이름(instance name)** 을 지정하여 인스턴스화한다.

## Module Description (1) Module Instantiation

```sv
module AND2(
    input in1,
    input in2,
    output out
);
    and u1 (out, in1, in2);
endmodule
```
앞선 슬라이드에서 본 것처럼,
하나의 **모듈 이름(module name)** 을 여러 번 재사용할 수 있다.
비록 같은 모듈 정의를 사용하더라도,
각 인스턴스(instance)는 **서로 독립적인 하드웨어 블록**으로 존재한다.

즉, 동일한 모듈을 여러 번 **인스턴스화(instantiation)** 하여 사용할 수 있으며,
각 인스턴스는 서로 다른 신호에 연결되거나
다른 물리적 위치에 배치될 수도 있다.

**모듈 정의(module definition)** 와 **모듈 인스턴스화(module instantiation)** 의 주요 차이는 다음과 같다.
- **정의(Definition)** 는 모듈의 동작과 구조(무엇을 하는가)를 기술한다.
- **인스턴스화(Instantiation)** 는 정의된 모듈을 실제 회로에 복제하여 사용한다(어디에, 어떻게 사용하는가).

```sv
module pe_single_batch #(
    parameter W_SLICE   = 4,
    parameter I_WIDTH   = 8,
    parameter I_CH      = 1024,
    parameter ACC_WIDTH = $clog2(I_CH),
    parameter M_WIDTH   = W_SLICE + I_WIDTH,
    parameter O_WIDTH   = W_SLICE + I_WIDTH + ACC_WIDTH,
    parameter O_CH      = 32
)(
    input  wire                   i_clk,
    input  wire                   i_rstn,
    input  wire                   i_en,
    input  wire                   i_first,
    input  wire [I_WIDTH-1:0]     i_ia,
    input  wire [W_SLICE-1:0]     i_w   [0:O_CH-1],
    output wire [O_WIDTH-1:0]     o_out [0:O_CH-1]
);

    //============================================================
    // Signal Declarations
    //============================================================
    genvar och;

    reg  [O_WIDTH-1:0] acc_out_reg [0:O_CH-1];
    wire [M_WIDTH-1:0] mult_out    [0:O_CH-1];
    wire [O_WIDTH-1:0] acc_in      [0:O_CH-1];
    wire [O_WIDTH-1:0] acc_out     [0:O_CH-1];
    wire [W_SLICE-1:0] mult_in_w   [0:O_CH-1];

    //============================================================
    // Assignments
    //============================================================
    generate
        for (och = 0; och < O_CH; och = och + 1) begin
            assign o_out[och]     = acc_out_reg[och];
            assign mult_in_w[och] = i_w[och];
            assign acc_in[och]    = {O_WIDTH{i_first}} & acc_out_reg[och];
        end
    endgenerate

    //============================================================
    // Instantiations (using Synopsys DW IPs)
    //============================================================
    generate
        for (och = 0; och < O_CH; och = och + 1) begin : GEN_MAC
            DW02_mult #(
                .A_width (I_WIDTH),
                .B_width (W_SLICE)
            ) mult_inst (
                .A       (i_ia),
                .B       (mult_in_w[och]),
                .TC      (1'b1),
                .PRODUCT (mult_out[och])
            );

            DW01_add #(
                .width (O_WIDTH)
            ) add_inst (
                .A   ({{ACC_WIDTH{mult_out[och][M_WIDTH-1]}}, mult_out[och]}),
                .B   (acc_in[och]),
                .CI  (1'b0),
                .SUM (acc_out[och]),
                .CO  ()
            );
        end
    endgenerate

endmodule

```
예를 들어, 그림에서 네 개의 동일한 하드웨어 모듈이 인스턴스화되어 있다.
```sv
generate
    for (och = 0; och < O_CH; och = och + 1) begin
        assign mult_in_w[och] = i_w[och];
        assign acc_in[och]    = {O_WIDTH{i_first}} & acc_out_reg[och];
    end
endgenerate
```
```sv
DW02_mult #(
    .A_width (I_WIDTH),
    .B_width (W_SLICE)
) mult_inst (
    .A       (i_ia),
    .B       (mult_in_w[och]),
    .TC      (1'b1),
    .PRODUCT (mult_out[och])
);

DW01_add #(
    .width (O_WIDTH)
) add_inst (
    .A   ({{ACC_WIDTH{mult_out[och][M_WIDTH-1]}}, mult_out[och]}),
    .B   (acc_in[och]),
    .CI  (1'b0),
    .SUM (acc_out[och]),
    .CO  ()
);
end
```
이들은 모두 같은 동작을 수행하지만, 각 인스턴스는 서로 다른 입력과 출력을 가지며 독립적으로 작동한다.
따라서 동일한 회로를 여러 번 반복해서 작성할 필요 없이,
한 번 정의한 모듈을 **필요한 위치마다 재사용(reuse)** 할 수 있다.

예를 들어, 이번 예시에서는 **`multiplier`**(곱셈기)와 **`adder`**(가산기)라는 이름의 모듈을 볼 수 있다.
이들은 설계 내에서 `mul_inst`, `add_inst` 와 같은 **인스턴스 이름(instance name)** 으로 사용된다.

동일한 모듈을 여러 번 사용하고 싶다면,
같은 모듈 이름(예: `DW02_mult`)을 재사용하되,
각 인스턴스에 **서로 다른 이름(inst1, inst2 등)** 을 부여하면 된다.
각 인스턴스는 동일한 기능을 수행하지만,
물리적으로 독립된 하드웨어 블록으로 동작한다.

또한 **덧셈(addition)**, **곱셈(multiplication)** 과 같은 기본 연산의 경우에는
별도의 모듈을 만들지 않아도 된다.
Verilog에는 이미 이러한 연산을 수행하는 **내장 연산자(`+`, `-`, `*`, `/` 등)** 가 존재하기 때문이다.

하지만 **새로운 기능 블록(custom functional block)**,
즉 내장 기호로 표현할 수 없는 연산을 설계할 때는
반드시 **새로운 모듈을 정의하고 인스턴스화**해야 한다.

## Module Description (2) Using assign

**조합 논리 회로(combinational logic circuit)** 를 정의할 때는
**`assign` 문**을 사용해야 한다.
이는 **데이터플로우(dataflow) 방식**으로 회로의 동작을 기술하는 방법이다.

앞서 설명했듯이, 조합 논리 회로는 **수학적 함수(function)** 와 같다.
즉, **출력(output)** 은 오직 **현재 입력(input)** 값에만 의존한다.
예를 들어, 두 입력을 갖는 **AND 게이트**를 표현하려면 다음과 같이 작성한다:

```sv
module AND2(
    input in1,
    input in2,
    output out
);
    assign out = in1 & in2;
endmodule
```
이 구문은 출력 `out`가 입력 `in1`와 `in2`의 논리적 AND 연산 결과임을 의미한다.
모든 `assign` 문은 반드시 **세미콜론(`;`)** 으로 끝나야 한다.
이는 Verilog 문법에서 하나의 문(statement)이 끝났음을 나타낸다.

## Module Description (3) Using always

Verilog에서는 **`always` 문**도 사용할 수 있다.
`assign` 문이 **데이터플로우(dataflow)** 방식이라면,
`always` 문은 **행위적(behavioral)** 방식으로 회로를 기술한다.

행위적 방식에서는, 회로의 **입력 신호가 변화할 때마다**
출력이 어떻게 반응해야 하는지를 정의한다.

예를 들어, 다음과 같은 코드를 보자:

```sv
module AND2(
    input in1,
    input in2,
    output reg out
);
    always @(in1, in2)
        out = in1 & in2;
endmodule
```

이 구문은 `in1` 또는 `in2` 중 어느 하나라도 변할 때마다
출력 `out`이 두 입력의 AND 연산 결과로 갱신됨을 의미한다.
즉, 입력 변화에 즉각적으로 반응하는 **조합 논리 회로**의 동작을 표현한다.

하지만 **순수한 조합 논리 회로**를 기술할 때는
`always` 문보다는 **`assign` 문을 사용하는 것을 권장**한다.
왜냐하면 두 방식을 혼용하면 코드의 의미가 모호해질 수 있기 때문이다.

따라서 **조합 논리 회로(combinational logic)** 는 `assign` 문으로,
**순차 논리 회로(sequential logic)** 는 `always` 문으로 기술하는 것이 가장 바람직하다.

때때로 **`case` 문**이나 기타 제어 구문을 사용해야 할 경우에는
조합 논리를 **`always` 블록**으로 작성하는 것이 편리할 수도 있다.
하지만 이런 **특수한 경우를 제외하고는**,
조합 논리 회로는 **`always` 문 대신 `assign` 문**을 사용하는 것이 좋다.

이제 **순차 논리 회로(sequential logic)** 를 설계할 때
`always` 문을 올바르게 사용하는 방법을 살펴보자.

```sv
module pe_single_batch #(
    parameter W_SLICE   = 4,
    parameter I_WIDTH   = 8,
    parameter I_CH      = 1024,
    parameter ACC_WIDTH = $clog2(I_CH),
    parameter M_WIDTH   = W_SLICE + I_WIDTH,
    parameter O_WIDTH   = W_SLICE + I_WIDTH + ACC_WIDTH,
    parameter O_CH      = 32
)(
    input  wire                   i_clk,
    input  wire                   i_rstn,
    input  wire                   i_en,
    input  wire                   i_first,
    input  wire [I_WIDTH-1:0]     i_ia,
    input  wire [W_SLICE-1:0]     i_w   [0:O_CH-1],
    output wire [O_WIDTH-1:0]     o_out [0:O_CH-1]
);

    //============================================================
    // Signal Declarations
    //============================================================
    genvar och;

    reg  [O_WIDTH-1:0] acc_out_reg [0:O_CH-1];
    wire [M_WIDTH-1:0] mult_out    [0:O_CH-1];
    wire [O_WIDTH-1:0] acc_in      [0:O_CH-1];
    wire [O_WIDTH-1:0] acc_out     [0:O_CH-1];
    wire [W_SLICE-1:0] mult_in_w   [0:O_CH-1];

    //============================================================
    // Assignments
    //============================================================
    generate
        for (och = 0; och < O_CH; och = och + 1) begin
            assign o_out[och]     = acc_out_reg[och];
            assign mult_in_w[och] = i_w[och];
            assign acc_in[och]    = {O_WIDTH{i_first}} & acc_out_reg[och];
        end
    endgenerate

    //============================================================
    // Instantiations (using Synopsys DW IPs)
    //============================================================
    generate
        for (och = 0; och < O_CH; och = och + 1) begin : GEN_MAC

            // Signed Multiplier
            DW02_mult #(
                .A_width (I_WIDTH),
                .B_width (W_SLICE)
            ) mult_inst (
                .A       (i_ia),
                .B       (mult_in_w[och]),
                .TC      (1'b1),                 // signed multiplication
                .PRODUCT (mult_out[och])
            );

            // Adder with accumulator
            DW01_add #(
                .width (O_WIDTH)
            ) add_inst (
                .A   ({{ACC_WIDTH{mult_out[och][M_WIDTH-1]}}, mult_out[och]}),
                .B   (acc_in[och]),
                .CI  (1'b0),
                .SUM (acc_out[och]),
                .CO  ()
            );

            // Register stage
            always @(posedge i_clk or negedge i_rstn) begin
                if (!i_rstn)
                    acc_out_reg[och] <= 'd0;
                else if (i_en)
                    acc_out_reg[och] <= acc_out[och];
            end

        end
    endgenerate
endmodule
```
아래 예시에서 볼 수 있듯이,
순차 논리용 `always` 블록은 조합 논리용과 달리
**엣지(edge) 트리거 이벤트**를 포함한다.

```sv
always @(posedge i_clk or negedge i_rstn) begin
    if (!i_rstn)
        acc_out_reg[och] <= 'd0;
    else if (i_en)
        acc_out_reg[och] <= acc_out[och];
end
```
이 구문은 **클록의 상승 에지(`posedge`)** 또는
**리셋 신호의 하강 에지(`negedge`)** 가 감지될 때만 실행된다.

반면 조합 논리용 `always` 블록은
입력 신호의 모든 변화(상승, 하강 구분 없이)에 반응한다.
즉, 순차 논리용 `always` 블록은 **엣지(변화 순간)에만 반응**하는 반면,
조합 논리용 `always` 블록은 **모든 신호 변화에 반응**한다.
이것이 두 방식의 핵심적인 차이점이다.

보통 **`always` 문**은 **클록(clock)** 이나 **리셋(reset)** 신호와 함께 사용한다.
일반적인 **`wire` 신호**를 트리거 조건으로 사용하는 것은 거의 없다.

이유는 그러한 사용 방식이 **Verilog의 일반적인 설계 스타일에 맞지 않으며**,
회로의 동작을 오해하거나 혼란을 줄 수 있기 때문이다.
따라서 `always` 블록은 주로 **엣지 트리거(edge-triggered)** 신호를 감지하도록 작성한다.

예를 들어:
- `posedge clk` -> 클록의 상승 에지에서 동작
- `negedge reset` -> 리셋의 하강 에지에서 동작
- 또는 리셋이 하이(active-high)일 경우 `posedge reset`

이와 같은 형태는 **순차 회로(sequential circuit)** — 예를 들어 플립플롭(flip-flop)이나 레지스터(register) — 를 설계할 때 표준적으로 사용된다.

## Testbench: Testing the Module

모듈을 정의한 후에는, 그 동작을 검증하기 위해 **테스트벤치(testbench)** 를 작성해야 한다.
앞서 설명했듯이 테스트벤치는 **입출력 포트(port)** 를 정의하지 않는다.

대신 **테스트 대상 모듈(target module)** 을 인스턴스화하고,
필요한 **입력 신호(test signals)** 를 직접 생성하여 전달한다.

테스트벤치 안의 **`initial` 블록**은
**C**나 **Python** 코드와 비슷하게 **순차적으로(sequentially)** 실행된다.

예를 들어:

```sv
module test_and2;
    reg i1, i2;
    wire o;

    AND2 u2(i1, i2, o);

    initial begin
        i1=0; i2=0;
        #1 $display("i1=%b, i2=%b, o=%b", i1, i2, o);
        i1=0; i2=1;
        #1 $display("i1=%b, i2=%b, o=%b", i1, i2, o);
    end
endmodule
```

이 예제의 실행 순서는 다음과 같다.

1. `i1 = 0` 실행
2. `i2 = 0` 실행
3. 1 시간 단위(delay) 후 `$display` 문을 통해 출력값을 콘솔에 표시
4. `i1 = 0` 실행
5. `i2 = 1` 실행
6. 1 시간 단위(delay) 후 `$display` 문을 통해 출력값을 콘솔에 표시

이처럼 `initial` 블록은 시간 흐름에 따라 단계적으로 실행되는 구조를 갖는다.

참고로,
- **클록 동기(always) 블록**에서는 병렬 업데이트를 표현하기 위해 **비차단 할당(`<=`)** 을 사용한다.
- 반면 **초기(initial) 블록**에서는 순차적 실행을 나타내기 위해 **차단 할당(`=`)** 을 사용한다.
또한 `initial` 블록의 각 명령은 **세미콜론(`;`)** 으로 구분되며,
작성된 순서대로 실행되어 **순차적 동작**을 모의(simulate)한다.


지금까지는 Verilog의 전반적인 구조를 살펴보았다.
즉, **모듈 정의(module definition)** 부터 **테스트벤치(testbench)** 작성까지의 과정을 다루었다.
다음 강의에서는 보다 **구체적이고 실용적인 예제(detailed examples)** 를 통해
Verilog 프로그래밍을 계속해서 학습하고 복습할 예정이다.

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>
<script type="text/x-mathjax-config"> MathJax.Hub.Config({ tex2jax: {inlineMath: [['$', '$']]}, messageStyle: "none" });</script>