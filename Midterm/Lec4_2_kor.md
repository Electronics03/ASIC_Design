# Lec4-2

## Verilog Module define

이전에 우리는 몇 가지 모듈 정의에 대해 이야기했었다.
또한 이전 강의에서는 `always` 구문과 `assign` 문을 사용하여 하드웨어 동작을 기술하는 방법에 대해서도 다루었다.
따라서 이번 강의는 Verilog 설계, 특히 조합 논리(combinational logic) 설계에 대한 요약이 될 것이다.

가장 중요한 점은, 예를 들어 3입력 AND 게이트나 3입력 OR 게이트와 같은 하드웨어 모듈을 정의할 수 있다는 것이다.
```sv
module AND_logic_3in(
	input wire in1, in2, in3,
	output wire out
);
	assign out = in1 & in2 & in3;
endmodule
```
```sv
module OR_logic_3in(
	input wire in1, in2, in3,
	output wire out
);
	assign out = in1 | in2 | in3;
endmodule
```
이러한 모듈은 테스트벤치(testbench) 내부에서 검증할 수 있다.
각 하드웨어 모듈을 정의할 때는 입력(input) 또는 출력(output) 포트를 반드시 정의해야 한다.
하지만 테스트벤치를 정의할 때는 입력과 출력을 정의할 필요가 없다.
그 이유는 모든 테스트가 테스트벤치 모듈 내부에서 수행되기 때문이다.
```sv
module tb_AND_logic_3in;
	reg signal_a;
	reg signal_b;
	reg signal_c;
	wire output_and;
	wire output_or;

	AND_logic_3in module_1(signal_a, signal_b, signal_c, output_and);
	OR_logic_3in module_1(signal_a, signal_b, signal_c, output_or);

	initial begin
		signal_a = 1'b0; signal_b = 1'b0; signal_c = 1'b0; #10;
		$display("a=%b, b=%d, c=%b, out_and=%b, out_or%b", 
			signal_a, signal_b, signal_c, output_and, output_or);

		signal_a = 1'b0; signal_b = 1'b0; signal_c = 1'b1; #10;
		$display("a=%b, b=%d, c=%b, out_and=%b, out_or%b", 
			signal_a, signal_b, signal_c, output_and, output_or);

			...
	end
endmodule
```
우리가 미리 정의한 모듈을 테스트하기 위해서는 일반적으로 `register` 데이터 타입을 사용하여 몇 가지 신호를 정의한다.
그 이유는 신호 a, b, c의 값을 제어해야 하기 때문이다.

이 신호들의 값을 제어하거나 변경하는 방법으로는 `initial` 문을 사용한다.
`initial` 문의 주요 특징은, 그 안에 포함된 코드가 **순차적(sequential)으로 한 번만 실행된다는 것**이다.
이후 출력 결과를 얻을 수 있으며, 이 출력은 `display`, `readmem`, `writemem` 등의 함수를 통해 화면에 출력하거나 메모리에 읽고 쓸 수 있다.

이러한 예시는 이미 이전에 제공한 **Verilog 환경 설치 및 실습 영상** 속에 포함되어 있다.
그 영상에서 조합 논리 회로 설계 — 즉 AND 논리 회로, AND 게이트, OR 게이트 — 를 연습해보기 바란다.

## Hierarchical Specification

이번 강의에서는 이전에 다루었던 블록 다이어그램의 구현 세부 사항은 생략하겠다.
대신 Verilog 프로그램의 개념적 구조와 문법(grammar)에 대해 계속 설명하겠다.
여기에서 볼 수 있듯이, 서로 다른 두 개의 모듈은 테스트벤치에서 함께 테스트될 것이다.
앞서 언급했듯이, Verilog 언어는 **계층적(hierarchical) 프로그래밍 언어 구조**를 가진다.
따라서 각 하드웨어 블록은 **기본 단위(basic unit)** 로서 `module`이라는 용어를 사용해 정의된다.

모듈 내부에는 **구조적(structural)** 또는 **비구조적(non-structural)** 기능적 요소들이 포함될 수 있다.
즉, 하나의 모듈은 `assign` 문이나 `always` 문을 사용하여 **조합 논리 회로** 또는 **순차 논리 회로**를 포함할 수 있다.
또한 `initial` 문을 사용할 수도 있는데, 이는 **테스트벤치에서만 사용하는 것을 권장한다.**
하드웨어를 실제로 기술하는 설계 모듈 내부에서는 `initial` 문을 사용하지 말아야 한다.
`module` 정의 안에서는 오직 `assign` 문과 `always` 문만을 사용하는 것이 올바르다.


각 모듈은 **포트(port)** 를 통해 다른 모듈들과 통신해야 한다.
이 포트는 `input`, `output`, 또는 `inout` 으로 정의할 수 있다.
모듈을 정의한 후, 그 모듈은 다른 모듈 내부에서 **인스턴스화(instantiation)** 되어야 한다.
인스턴스화를 수행하려면, `모듈 이름(module name)`과 `인스턴스 이름(instantiation name)`을 정의해야 한다.
이 인스턴스화의 의미는 **동일한 기능을 가진 하드웨어 블록을 복제(copy)** 하는 것이다.

물론 실제 구현에서는 여러 개의 블록이 존재하지만, 예를 들어 A 블록과 B 블록은 **동일한 기능, 동일한 입력/출력 정의, 동일한 조합 및 순차 논리 구조**를 가진다.
차이점은 단지 이러한 기능들이 **복제(copy)** 되어 각각의 인스턴스로 존재한다는 점뿐이다.
즉, 동일한 동작을 수행하는 블록을 복사하여 여러 인스턴스로 사용하는 것이다.

예를 들어, A0와 B0를 입력으로 하고 C0를 출력으로 가지는 **가산기(adder)** 모듈이 있다고 하자.
이 모듈을 `adder` 로 정의했다면, A1과 B1에 대해서도 같은 덧셈 동작을 수행하고 싶을 것이다.
이때 새로운 코드를 다시 작성할 필요 없이, 기존의 `adder` 모듈 정의를 그대로 복사하여 다른 이름으로 **인스턴스화(instantiation)** 하면 된다.
예를 들어 첫 번째 인스턴스를 `U0`, 두 번째 인스턴스를 `U1`로 정의하면, 같은 기능을 가진 두 개의 모듈이 서로 다른 이름으로 작동하게 된다.
```sv
adder U0(...);
adder U1(...);
```
이렇게 정의된 `U1` 인스턴스는 A1과 B1의 덧셈을 수행하여 C1을 출력하게 된다.
이처럼 모듈을 인스턴스화(instantiation)하면, **계층적 정의(hierarchical definition)** 나 **계층적 명세(hierarchical specification)** 를 구현할 수 있다.
```sv
adder #(4) U0(...);
adder #(5) U1(...);
```
또한 각 모듈은 설계 목적에 따라 **매개변수(parameter)** 를 포함하여 정의할 수도 있다.
즉, 모듈이 서로 다른 비트 폭(bit width)이나 하이퍼파라미터를 가지도록 설계하는 것도 가능하다.
이후 강의에서 이러한 **매개변수화된 모듈(parameterized module)** 의 구현 방법을 자세히 다루겠다.

서로 다른 파라미터를 가진 모듈을 인스턴스화하려면, 해당 문법을 이용하여 **다른 하이퍼파라미터 값**으로 모듈을 정의할 수 있다.

## Module Interconnection

### 입출력 포트의 순서(order)

그럼 이제 **모듈 간 연결(module interconnection)** 에 대해 살펴보자.
앞서 언급했듯이, 모듈을 인스턴스화할 때는 반드시 **입출력 포트의 순서(order)** 를 지켜야 한다.
즉, 모듈 이름(module name), 인스턴스 이름(instantiation name), 그리고 입력·출력 포트에 연결될 신호(signal)를 동일한 순서로 나열해야 한다.
인스턴스화할 때 이러한 순서를 올바르게 따라야 한다.

```sv
module my_gate(
	output out, 
	input i1, i2
);
...
endmodule
```
예를 들어, `my_gate`라는 모듈이 있고 세 개의 포트를 가진다고 하자.
첫 번째는 출력 포트 `o`, 두 번째는 입력 포트 `i1`, 세 번째는 입력 포트 `12`이다.
이 모듈을 정의할 때 세 개의 포트를 이 순서로 선언했다면, 인스턴스화할 때도 동일한 순서를 따라야 한다.
```sv
my_gate g1(out, in1, in2);
```
그러나 포트의 순서를 따르지 않고 싶다면, 인스턴스화 시에 **포트 이름을 명시적으로 지정(dot notation)** 하면 된다.
예를 들어, `.i1(in1), .i2(in2), .o(out)` 과 같이 작성하면 포트 순서에 상관없이 올바른 연결이 이루어진다.
```sv
my_gate g1(.i1(in1), .i2(in2), .o(out));
```
이와 같은 방법으로 포트 이름을 명시하면 연결 순서를 자유롭게 변경할 수 있다.

### 신호(signal)의 정의

다음으로, 신호(signal)를 정의할 때 단순히 `1`, `0` 또는 정수 값을 직접 입력하면,
이 값들은 **기본적으로 32비트(32-bit)** 로 해석된다.
하지만 대부분의 경우 우리가 의도한 것은 “1비트 신호를 정의하고 싶다”일 것이다.
이럴 때는 `1'b1` 과 같은 형식으로 작성해야 한다.
이 표현은 **‘1비트 크기의 2진수 값 1’** 을 의미한다.
예를 들어, `1'b0`은 1비트의 0을, `1'b1`은 1비트의 1을 뜻한다.
반면 `b101`과 같이 비트 폭을 지정하지 않으면, Verilog는 이를 32비트 크기의 값으로 해석하며,
상위 비트(MSB)는 자동으로 0으로 채워진다.

따라서 정수를 정의할 때는 반드시 **비트 폭(bit width)** 을 명시하는 것을 권장한다.
비트 폭을 정의하지 않으면, Verilog가 기본 32비트로 처리하기 때문에 하드웨어 설계 과정에서 혼동을 일으킬 수 있다.
특히 데이터 폭이 정확히 일치하지 않을 경우, 시뮬레이션이나 합성 과정에서 오류나 예기치 않은 동작이 발생할 수 있다.
즉, 비트 폭을 지정하지 않으면 하드웨어의 동작을 오해하거나 예측하기 어려워질 수 있다.


정리하자면, 모듈을 인스턴스화할 때는 기본적으로 **포트 선언 순서(port order)** 를 따라야 한다.
그러나 포트 이름을 명시적으로 지정(`.port_name(signal)`)하면, 순서를 변경하더라도 문제가 없다.
즉, 포트를 연결할 때 반드시 **정의된 이름과 대응되는 신호를 명확히 지정하는 것**이 가장 안전한 방법이다.
이것이 Verilog에서 포트를 연결할 때 반드시 지켜야 할 기본 규칙이다.

## Port Connection Rules

### wire

앞서 언급했듯이, **모듈의 입력 포트(input port)** 는 반드시 **net 타입**으로 정의해야 한다.
가장 대표적인 **net** 타입은 `wire` 이다.
`wire`의 의미는, 특정 출력 조건에 따라 데이터를 **전달(transfer)** 하기 위한 신호라는 뜻이다.
`wire`는 `initial` 문이나 `always` 문을 사용해서 직접 값을 제어할 수 없다.
즉, `wire`는 스스로 값을 저장하거나 변경하지 않고, **출력으로부터 전달된 값을 단순히 전송하는 역할만 한다.**

예를 들어, 2입력 AND 게이트를 정의한다고 하자.
입력 신호를 `i0`, `i1`, 출력 신호를 `out`이라고 하면,
보통 다음과 같이 `wire` 타입으로 정의한다:

```verilog
assign out = i0 & i1;
```
이렇게 하면 `i0`과 `i1`이 변할 때마다 `out`은 자동으로 그 결과를 반영하게 된다.


앞서 설명했듯이, `wire`의 본질적인 의미는 **연결(connection)** 이다.
즉, 신호의 값을 제어하는 것이 아니라, 단순히 데이터를 전달만 하는 것이다.
예를 들어 AND 연산을 수행할 때, 입력 `i0`과 `i1`은 각각 `wire` 신호로부터 데이터를 받아오며,
이 두 입력의 논리곱(AND) 결과가 계산되어 출력 `out`으로 전달된다.
이때 `out` 역시 `wire`로 정의되며, 계산된 결과를 외부로 전달하는 통로 역할을 한다.
결국 `wire`는 단순히 **데이터를 전달하는 연결선** 역할만 수행한다.

즉, `wire` 데이터 타입의 역할은 **데이터를 받아서 전달하는 것**뿐이다.
값을 저장하거나 변경하는 기능은 전혀 없다.
`wire`는 단지 어떤 연산 결과를 외부로 전달하는 통로로서만 동작한다.

이 때문에 **입력 포트(input port)** 는 `register` 타입이 아니라 반드시 **net 타입**,
즉 `wire`로 정의해야 한다.
입력 포트는 외부로부터 신호를 **받는 역할**만 하기 때문에,
그 신호의 값을 내부에서 변경할 수 없기 때문이다.
따라서 입력 포트는 항상 `wire`형으로 선언해야 한다.

따라서 일반적으로 **조합 논리 회로(combinational logic circuit)** 를 정의할 때는
`assign` 문을 사용한다.
예를 들어 AND 게이트나 OR 게이트와 같은 회로는
`wire` 신호 간의 연결(`assign`)을 통해 쉽게 기술할 수 있다.

### reg

반면, **순차 논리 회로(sequential logic circuit)** 나 **메모리 요소(memory component)** 를 다루려면
`always` 문이나 `initial` 문을 사용해야 한다.
그러나 실제 하드웨어 설계에서는 **`always` 문을 이용해 순차 회로를 설계하고**,
`initial` 문은 **테스트벤치(testbench)** 에서만 사용하는 것을 권장한다.


Verilog에는 `task` 또는 `function` 과 같은 구조도 있다.
이들은 C나 Python의 함수처럼 **동작을 기술하기 위한 기능적 단위**를 정의하는 것이다.
즉, **하드웨어 구조를 직접 표현하는 것이 아니라**, 특정 연산이나 기능을 묘사하는 용도로 사용된다.

또한 `case` 문도 존재하는데, 이는 **순차 논리 회로가 아닌 조합 논리 회로**를 표현할 때 사용된다.
조건에 따라 여러 입력 중 하나를 선택하는 구조를 기술할 때 매우 유용하다.
일반적으로 **조합 논리 회로**는 `assign` 문으로 정의하지만,
때로는 `case` 문을 사용해 조합 회로를 표현할 수도 있다.
다만, `case` 문을 사용할 때는 출력 신호를 `register` 타입으로 선언해야 한다.

그 이유는 Verilog가 해당 변수가 조합 회로인지 순차 회로인지 구분하지 않기 때문이다.
즉, 내부적으로 데이터를 일시적으로 저장하거나 판단해야 할 때,
Verilog는 이를 `register` 타입으로 취급한다.
따라서 `case` 문을 사용하는 경우, 반드시 출력 신호를 `reg` 타입으로 정의해야 한다.

---

정리하자면, **조합 논리 회로(combinational logic circuit)** 를 설계할 때는
`assign` 문과 모듈 간의 연결을 사용하는 것을 권장한다.
또한 필요한 경우 `case` 문을 함께 사용할 수도 있다.

반면, **순차 논리 회로(sequential logic circuit)** 를 설계할 때는
`always` 문을 사용하는 것이 가장 바람직하다.

그 외의 문법인 `initial`, `task`, `function` 등은
**테스트벤치(testbench)** 설계에서만 사용하는 것을 권장하며,
하드웨어 동작을 정의하는 모듈 내부에서는 사용하지 않는 것이 좋다.

`case` 문이나 `always` 문처럼 변수 값을 저장하거나 갱신해야 하는 경우에는
해당 변수를 반드시 **`reg` 타입**으로 정의해야 한다.
반면 단순히 연결만 필요한 경우(즉, 조합 회로나 포트 간 연결)에는
`wire` 와 같은 **net 타입**을 사용해야 한다.
즉, **`reg` -> 값 저장**, **`wire` -> 연결 전송** 이라는 개념을 기억해야 한다.

### MUX 예시

이제 예시를 통해 살펴보자.
다음은 **4개의 입력을 가진 멀티플렉서(Multiplexer, MUX)** 의 예이다.

입력 포트(`in0`, `in1`, `in2`, `in3`)는 각각 **1비트 입력 신호**로 정의되어 있다.
출력 포트(`out`)는 **`reg` 타입**으로 선언되어 있으며,
선택 신호(`sel`)는 **2비트의 입력 신호**로 정의되어 있다.
즉, `sel` 값에 따라 4개의 입력 중 하나를 출력으로 전달하는 구조이다.


이와 같은 멀티플렉서의 동작에서는,
입력 `in0`, `in1`, `in2`, `in3` 중 어느 하나라도 값이 바뀌거나,
또는 선택 신호(`sel`)가 바뀌면,
출력(`out`)을 새로 계산해야 한다.

하지만 입력이 많아질수록 `always` 문에서 모든 신호를 나열하기가 어렵다.
이럴 때는 `always @(*)` 구문을 사용하면 된다.

`always @(*)` 는 **“어떠한 입력 신호라도 변화가 생기면 아래의 코드 블록을 실행하라”**
라는 의미를 가진다.
즉, 변화 감지 목록을 일일이 나열하지 않고,
모든 입력 변화에 자동으로 반응하도록 하는 간편한 문법이다.

또한 포트를 정의하는 방법에는 두 가지가 있다.

첫 번째 방법은,
모듈 선언부에서 포트 이름만 나열한 뒤,
모듈 내부에서 각각의 포트 방향(`input`, `output`, `inout`)과 데이터 타입(`wire`, `reg`)을 따로 정의하는 방식이다.
```sv
module Mux4(in0, in1, in2, in3, out, sel);
	input wire in0, in1, in2, in3;
	output reg out;
	input wire [1:0] sel;

	always @(in0 or in1 or in2 or in3 or sel)
		case (sel)
			2'b00: out <= in0;
			2'b01: out <= in1;
			2'b10: out <= in2;
			2'b11: out <= in3;
		endcase
endmodule
```

두 번째 방법은,
**모듈 선언부에서 바로 포트 방향과 데이터 타입을 함께 정의하는 방식**이다.
즉, 아래와 같이 하나의 선언부에 모두 포함할 수 있다
```sv
module Mux4(
	input wire in0, in1, in2, in3;
	output reg out;
	input wire [1:0] sel;
);

	always @*
		case (sel)
			2'b00: out <= in0;
			2'b01: out <= in1;
			2'b10: out <= in2;
			2'b11: out <= in3;
		endcase
endmodule
```
두 방식 모두 Verilog 문법상 올바르며,
편의에 따라 선택하여 사용할 수 있다.
즉, 포트 정의부를 통합하거나 분리하는 것은 설계자의 선택이다.

이 예시에서 `always` 문은 **클록(clock)** 이나 **리셋(reset)** 을 사용하지 않는다.
즉, `@(posedge clk)` 또는 `@(negedge clk)` 와 같은 구문이 없다면,
그 내부에 작성된 로직은 **조합 논리 회로(combinational logic)** 로 해석된다.

비록 출력 신호가 `reg` 타입으로 정의되어 있더라도,
클록 신호에 의존하지 않는 `always` 블록(`always @(*)`)은
**순차 회로가 아니라 조합 회로**를 의미한다.
즉, `reg` 타입은 단지 문법적 데이터 저장을 위한 선언일 뿐,
클록이 없다면 하드웨어적으로 플립플롭이 생성되지 않는다.

특히 `case` 문을 사용할 때는 출력 신호를 반드시 **`reg` 타입**으로 정의해야 한다.
이유는 `case` 문 내부에서 출력이 여러 조건에 따라 갱신되기 때문이다.

예를 들어, 선택 신호(`sel`)가 2비트일 때,
각 경우에 따른 출력 동작은 다음과 같다:

* `sel = 2'b00` -> `out = in0`
* `sel = 2'b01` -> `out = in1`
* `sel = 2'b10` -> `out = in2`
* `sel = 2'b11` -> `out = in3`

이처럼 `case` 문은 입력 신호의 조합에 따라 다른 출력을 선택하기 때문에,
출력은 `always` 블록 내부에서 변경될 수 있다.
따라서 이러한 출력을 저장하기 위해서는 반드시 `reg` 타입으로 선언해야 한다.

이 예시는 4개의 입력 중 하나를 선택하여 출력을 만드는 **멀티플렉서(MUX)** 이다.
선택 신호(`sel`)가 추가되어, 그 값에 따라 어떤 입력이 출력으로 전달될지가 결정된다.
이러한 멀티플렉서 설계에서 `case` 문은 매우 유용하다.

하지만 Verilog 프로그래밍에 익숙하지 않은 초보자라면,
`case` 문을 이용한 MUX 설계는 **문법 오류를 유발하기 쉽기 때문에 추천하지 않는다.**
대신 단순한 `assign` 문을 이용해 조합 논리를 직접 기술하는 것이 더 안전하고 명확하다.
이에 대한 구현은 이후 강의에서 다룰 예정이다.

## Forbidden Module / Variable Name

Verilog에는 **예약어(reserved keyword)** 가 존재하며,
이 단어들은 변수명이나 모듈명으로 사용할 수 없다.

예를 들어 `always`, `assign`, `begin`, `case`, `else`, `if`, `initial` 등은
언어 문법을 구성하는 핵심 키워드이므로,
이들을 변수 이름이나 모듈 이름으로 사용하면 컴파일 오류가 발생한다.

이 개념은 C나 Python과 같은 프로그래밍 언어에서도 동일하다.
예를 들어 Python에서는 `def`가 함수 정의에 사용되므로 변수 이름으로 쓸 수 없으며,
C언어에서도 `int`, `float` 등은 데이터 타입으로 예약되어 있으므로 변수명으로 사용할 수 없다.
Verilog도 마찬가지로 이러한 예약어들을 변수명이나 인스턴스명으로 사용하는 것은 금지된다.


따라서 Verilog 프로그램 문법을 구성하는 용도로 사용되는 단어들은
**모듈 이름(module name)** 이나 **인스턴스 이름(instantiation name)** 으로 사용할 수 없다.

예를 들어 `module`, `endmodule`, `wire`, `reg`, `task` 등은
이미 문법적인 역할을 가지고 있기 때문에 변수명으로 지정할 수 없다.
또한 `and`, `or`, `not`, `xor`, `xnor`, `buf` 등은
**기본 논리 게이트(primitive logic gate)** 로 정의되어 있으므로
이 역시 사용자 정의 이름으로 사용하면 안 된다.

즉, Verilog는 기본 논리 게이트와 문법 구조를 구분하기 위해
일부 단어를 시스템적으로 보호(reserved)하고 있다.

## Lexical Conventions

### identifiers

또 다른 **문자 규칙(lexical convention)** 도 존재한다.
모듈 이름이나 변수 이름을 정할 때는 **영문자(A–Z, a–z)** 와 **숫자(0–9)** 를 사용할 수 있으며,
언더바(`_`)의 사용도 허용된다.
단, 맨 앞에 숫자가 오면 안되며 이는 C또는 Python 등 여타 다른 컴퓨터 언어의 규칙과 동일하다.

또한, **특수기호나 연산자 기호(!, @, #, $, %, ^, &, 등)** 는
특수 함수나 시스템 기능(`$display` 등)에서 사용되므로
이들을 이름으로 사용하는 것은 피해야 한다.

그리고 Verilog는 **대소문자를 구분(case-sensitive)** 하기 때문에
`SignalA`와 `signala`는 서로 다른 변수로 인식된다는 점도 주의해야 한다.

물론, 이러한 특수기호들은 **논리식(expression)** 을 작성할 때는 사용 가능하다.
예를 들어, `assign out = (A & B) | (~C & D);` 와 같은 형태로
AND(`&`), OR(`|`), NOT(`~`) 연산자를 사용하는 것은 허용된다.
즉, **연산 기호로서의 사용은 가능하지만, 이름(identifier)으로 사용하는 것은 금지된다.**


앞서 언급했듯이, Verilog는 **대소문자를 구분(case sensitive)** 한다.
즉, `SignalA` 와 `signala` 는 완전히 다른 식별자로 취급된다.

또한, Verilog의 키워드(`always`, `initial`, `assign`, `case`, `else`, `if` 등)는
항상 **소문자(lowercase)** 로 작성해야 한다.
대문자로 작성하면 문법적으로 인식되지 않는다.

### Comments

주석(comment)을 작성할 때는 `//` 기호를 사용하며,
이 기호 뒤에 오는 내용은 모두 컴파일에서 무시된다.

`/` 기호를 하나만 쓰면 **나눗셈 연산자(division operator)** 로 인식된다.
그러나 `//` 두 개를 연속으로 쓰면 **한 줄 주석(single-line comment)** 으로 인식된다.

여러 줄 주석을 작성하려면
`/*` 와 `*/` 사이에 내용을 넣으면 된다:

```verilog
/*  
   This is a multiple-line comment.
   It can span across several lines.
*/
```
이 블록 안의 모든 내용은 컴파일러가 무시한다.

### Text Substitution

Verilog에서는 코드를 단순화하기 위해 **텍스트 치환(Text Substitution)** 기능을 제공한다.  
`define` 지시어를 이용하면 특정 이름(name)에 문자열(string)이나 숫자 값을 미리 정의해 둘 수 있다.  
이때 `<name>`은 이후 코드에서 `<string>`으로 자동 대체된다.

예를 들어 다음과 같이 작성할 수 있다:
    `define delay #1

이후 코드에서 `delay`를 사용할 때마다 컴파일 전 단계에서 `#1`로 치환된다.  
즉, 아래 코드는:
    `delay s_in = 1;
컴파일 시
    #1 s_in = 1;
로 바뀐다.

이러한 매크로 정의는 반복되는 값이나 문자열을 명확하고 간결하게 표현할 수 있게 해 주며,  
특히 `$display` 함수에서 출력 문자열이나 일정한 시간 지연(delay)을 정의할 때 유용하다.


### Literal Strings

이 부분은 `$display` 함수를 사용할 때 문자열을 다루는 방법에 관한 것이다.
이는 C나 Python의 문자열 포맷팅 규칙과 매우 유사하다.

예를 들어:

* `\n` -> 줄바꿈(new line)
* `\t` -> 탭(tab)
* `\\` -> 역슬래시(`\`) 자체를 출력
* `\"` -> 문자열 내부에 큰따옴표(`"`) 출력

즉, `$display("Hello\nWorld");` 라고 하면
출력은 다음과 같이 된다:

```
Hello
World
```

또한, C 언어의 `printf` 와 마찬가지로 `%d`, `%b`, `%h`, `%s` 등의 포맷 지정자를 사용하여
정수, 2진수, 16진수, 문자열 등을 출력할 수 있다.

### Integers

이는 Verilog에서 **정수(integer)** 를 표현하는 방식에 대한 설명이다.
Verilog에서 숫자는 다음과 같은 형식을 따른다:

```
<size>'<base><value>
```

예를 들어 `8'd15` 는 “8비트 10진수 15”를 의미한다.

* 앞의 숫자(`8`)는 **비트 폭(bit width)**
* `'d`는 **10진수(decimal)** 형식임을 의미
* 마지막 숫자(`15`)는 **값(value)** 을 의미한다.

따라서 `4'b1010` 은 “4비트 2진수 값 1010(10진수 10)”을 뜻하며,
`16'hFF` 는 “16비트 16진수 값 FF(10진수 255)”를 의미한다.
이와 같이 각 숫자 표현에는 **비트 폭, 기수, 값**의 세 요소가 포함된다.

예를 들어, 단순히 숫자 `12`를 적으면
이는 **기본적으로 32비트 10진수 값 12** 로 해석된다.

하지만 `8'd45` 라고 쓰면,
이는 **8비트 크기의 10진수 45** 로 표현된다.

또한 `6'b010_110` 과 같이 작성하면
**6비트 2진수 값(010110)** 을 의미한다.

만약 비트 수보다 더 많은 자릿수를 입력하면,
초과된 비트는 **무시(ignore)** 되며,
비트 수보다 적게 입력하면 **부족한 자리는 0으로 채워진다.**
따라서 비트 폭을 정확히 지정하는 것이 중요하다.

예를 들어, 6비트 값 `6'b001010` 을 해석해보면
오른쪽부터 1, 2, 4, 8, 16, 32의 자릿값을 가지므로
$1 \times 2 + 1 \times 8 = 10$ 이 된다.
즉, `6'b001010` 은 10진수로 **10** 을 의미한다.

또 다른 예로 `4'b1011` 은
2진수 `1011` -> 16진수 `B` -> 10진수 `11` 과 동일하다.
이처럼 Verilog는 **2진수, 10진수, 16진수 간 변환 표현을 모두 지원한다.**

### Real Numbers

Verilog에서도 실수(real number)나 부동소수점(floating-point) 값을 표현할 수는 있다.
예를 들어 `real x = 3.14;` 와 같이 선언할 수 있다.

하지만 실제 **하드웨어 구현(synthesis)** 단계에서는
이러한 실수형 데이터는 거의 사용되지 않는다.
그 이유는 실수형은 64비트 IEEE 754 형식을 따라야 하며,
이를 하드웨어로 변환하려면 매우 복잡한 회로가 필요하기 때문이다.

따라서 **실수형 데이터는 시뮬레이션(testbench)** 에서만 사용하고,
실제 하드웨어 설계에서는 **고정소수점(fixed-point)** 또는 정수(integer) 표현을 사용하는 것이 일반적이다.

### Delay Specifications

다음으로는 **지연(delay)** 지정에 관한 내용이다.
앞서 언급했듯이, `#` 기호 뒤에 숫자를 쓰면 **지연 시간(delay time)** 을 지정할 수 있다.
예를 들어 `#1` 이라고 작성하면, **1 단위 시간 뒤에** 해당 동작이 수행된다는 의미이다.
```sv
module re_ff (
	output y, y_,
	input r, s
);
	nor #1 (y, r, y_);
	nor #1 (y_, s, y);
endmodule
```

특히 `initial` 블록 내에서 지연을 사용하면,
코드는 **순차적(sequential)** 으로 실행된다.
즉, 첫 번째 문장이 실행되고 -> `#1`만큼 기다린 뒤 -> 다음 문장이 실행되는 방식이다.
이때 지연 단위는 시뮬레이션 시간 단위(time unit)에 따라 다르다.
```sv
module test_reff;
	reg r_in, s_in;
	wire out, out_;

	re_ff D1(out, out_, r_in, s_in);

	initial begin
		r_in = 1'b0; s_in = 1'b0;
		#10; s_in = 1'b1;
		#10; s_in = 1'b0; r_in = 1'b0;
		#10 $finish;
	end
endmodule
```
이 코드에서는 `r_in`과 `s_in`이 처음에 0으로 설정되고,
10 단위 시간이 지난 후(`#10`) `s_in`이 1로 바뀐다.

`initial` 블록은 명령을 순차적으로 실행하지만,
모든 문장이 정확히 동시에 실행되는 것은 아니다.
지연(`#10`)이 포함된 문장은 지정된 시간만큼 기다린 후 실행된다.
즉, 코드의 순서는 순차적이지만,
지연이 있는 부분은 시뮬레이션 시간에 따라 시점이 나뉘어 실행된다.

계속 예시를 이어보면 다음과 같다:


* 처음에는 `Rin=0`, `Sin=0`
* 10 단위 시간이 지난 후 `Sin=1`
* 다시 10 단위 시간이 지나면 `Sin=0`
* 마지막으로 10 단위 시간이 지나면 `Rin=1`

이처럼 `#` 기호는 시뮬레이션 시간의 흐름을 제어하며,
각 신호가 변화하는 **시간적 순서**를 명확히 정의한다.
이 코드는 순차적으로 실행되며,
마지막 지연이 끝나면 해당 `initial` 블록이 종료된다.

시뮬레이션을 완전히 종료하려면
`initial` 블록의 마지막에 `$finish;` 문을 작성해야 한다.
이 명령이 실행되면 **전체 시뮬레이션이 종료된다.**

### System Tasks and System Functions

또한 시뮬레이션 중에 값을 출력하려면
`$display` 함수를 사용한다.
이 함수는 C 언어의 `printf()` 와 같은 역할을 한다.

예를 들어 다음과 같이 작성할 수 있다:
```sv
$display("Time=%0t, Rin=%b, Sin=%b", $time, Rin, Sin);
```
이 구문은 현재 시뮬레이션 시간과 각 신호의 값을 콘솔에 출력한다.

`$display` 함수의 사용법은 C나 Python의 문자열 포맷팅과 유사하다.

예를 들어 다음과 같이 작성하면:
```sv
$display("Test number = %3d", test_num - 1);
```

여기서 `%3d` 는 **3자리 정수 출력 형식**을 의미한다.
즉, `test_num - 1` 값이 한 자리 수라면
자동으로 앞에 공백이 추가되어 3자리를 맞춘다.
이와 같이 포맷 지정자를 이용하면
출력 형식을 보기 좋게 정렬할 수 있다.


이처럼 `%03d` 와 같은 서식 지정자를 사용하면
모든 숫자가 세 자리 형태로 출력된다.
예를 들어 출력 결과는 다음과 같다:

```
Test number = 001
Test number = 027
Test number = 126
```

이후 출력될 신호 값(`%d`)은
해당 테스트 케이스의 출력 결과를 함께 표시하는 데 사용될 수 있다.
즉, `$display` 문은 **테스트 케이스 번호와 결과를 함께 출력하는 용도**로 자주 활용된다.

## Data Types

앞서 언급했듯이, Verilog에서 주로 사용되는 데이터 타입은 두 가지이다:
**넷 타입(net type)** 과 **레지스터 타입(register type)** 이다.

### Nets
그중에서도 가장 대표적인 **넷 타입은 `wire`** 이다.
`wire`는 Verilog 전반에 걸쳐 가장 자주 사용되며,
특히 **조합 논리 회로(combinational logic circuit)** 를 기술할 때 거의 필수적으로 사용된다.
비록 Verilog에는 다양한 데이터 타입이 존재하지만,
기본적으로 `wire`는 신호 연결을 표현하는 가장 일반적이고 중요한 타입이다.

이처럼 `wire` 타입은 주로 조합 논리 회로를 기술할 때 사용된다.
일반적으로 `assign` 문과 함께 사용하여 입력과 출력을 연결한다.

하지만 `case` 문을 사용하여 조합 논리를 기술할 때는
`wire` 대신 **`reg` 타입**을 사용해야 한다.
그 이유는 `case` 문 내부에서 출력 신호의 값이 조건에 따라 변경되기 때문이다.
즉, `case` 문은 단순한 연결이 아니라 **상태를 갱신하는 동작**을 포함하므로
`wire`가 아닌 `reg` 타입 변수가 필요하다.

### Reg

다음은 또 다른 대표적인 데이터 타입인 **`register` 타입(`reg`)** 이다.
이 타입은 주로 **절차적 블록(procedural block)** 안에서 사용된다.
즉, `initial` 문이나 `always` 문 안에서 값이 변경되는 변수를 정의할 때 사용한다.

`reg` 타입의 역할은 **데이터를 저장하거나 유지하는 것**이다.
그러나 중요한 점은,
`reg`라고 해서 반드시 실제 하드웨어의 **레지스터(Register)** 나
**플립플롭(Flip-Flop)** 으로 구현된다는 뜻은 아니라는 것이다.
단지 Verilog 코드 상에서 “값을 기억할 수 있는 변수”를 의미할 뿐이다.

따라서 `reg` 타입은 문맥에 따라
하드웨어의 레지스터로 구현될 수도 있고,
그저 시뮬레이션용 저장 변수로만 쓰일 수도 있다.

`reg` 타입을 선언했다는 것은,
그 변수가 **정수형(integer)** 이나 **배열(array)** 형태의 데이터 저장에 사용될 수 있음을 의미한다.
즉, `reg` 타입은 “값을 저장할 수 있는 변수”라는 의미만 가지며,
그 자체로 하드웨어의 레지스터를 반드시 의미하는 것은 아니다.

따라서 `reg` 타입은 조합 논리 회로에서도 사용할 수 있지만,
일반적으로는 `always` 문과 함께 사용하여
**순차 논리 회로(sequential logic circuit)** 를 설계할 때 쓰인다.
즉, 클록(clock)에 동기화된 회로에서 상태를 저장하기 위한 용도로 자주 사용된다.

물론 Verilog에는 `integer` 또는 `longint` (64비트)와 같은
다른 수치형 데이터 타입도 존재한다.
이들은 주로 **루프 인덱스(loop index)** 나
**카운터(counter)** 등 시뮬레이션 과정에서 사용되는 변수에 적합하다.

하지만 실제 회로 설계에서는
`wire` 와 `reg` 두 가지 타입만으로도 대부분의 조합 및 순차 논리 회로를 표현할 수 있다.
따라서 **하드웨어 설계에서는 `wire`와 `reg` 중심의 코딩 습관을 유지하는 것이 좋다.**

앞서 언급한 것처럼,
`wire` 타입으로 정의된 신호는 주로 `assign` 문과 함께 사용된다.
즉, **즉시 연결되는 조합 논리 회로**를 표현하는 데 쓰인다.

반면, `reg` 타입 변수는 `always` 문 내부에서 사용되며,
**클록 동기화 연산이나 상태 저장 로직**을 표현할 수 있다.
결국 두 타입의 가장 큰 차이는
값을 **즉시 연결하느냐(assign)** 또는 **시간에 따라 갱신하느냐(always)** 에 있다.

정리하자면 다음과 같다:

* **`assign` 문**을 사용한다면 -> `wire` 타입 사용
* **`always` 문**을 사용한다면 -> `reg` 타입 사용

이 규칙을 기억해두면 대부분의 Verilog 코드 작성 시 문법 오류를 피할 수 있다.
즉, `assign` 은 **조합 회로**, `always` 는 **순차 회로**를 표현한다고 생각하면 된다.

추가적으로,
`initial` 문 내부에서 데이터를 제어하는 경우에도
`reg` 타입 변수를 사용해야 한다.
또한 `case` 문이 `always` 문과 결합되어 있는 경우에도
출력 신호는 `reg` 타입으로 선언되어야 한다.

정리하면 다음과 같다:

* `assign` 또는 모듈 간 연결용 -> **`wire` 타입**
* `always`, `initial`, `case` 등 내부 제어문 포함 -> **`reg` 타입**

즉, 단순 연결이 아니라 신호 값을 변경하거나 제어해야 하는 경우에는
항상 `reg` 타입을 사용하는 것이 원칙이다.

## Data Declaration Syntax

지금 여기에서 보이듯이, 아마 이제는 `register`나 `wire` 데이터 타입에 익숙할 것이다. 이것들은 각각의 변수의 이름을 나타내는 것이다. 그러나 여기서 보듯이, 두 가지 다른 형식 혹은 패밀리가 있다. 이 슬라이드에서 그것이 무엇인지 설명하겠다.

일반적으로 어떤 데이터 타입을 정의하려면, 데이터 타입으로 시작해야 한다. 즉, `register` 또는 `wire`가 될 수 있다. 그리고 그 다음 부분에서 전체 비트 폭(bit width)을 정의한다.

이진 스트림(binary stream)을 만들 때, 우리는 오른쪽 끝의 비트를 **최하위 비트(LSB, Least Significant Bit)** 라고 부른다. 즉, 오른쪽에 위치한 비트가 LSB이다. 반대로, 왼쪽에 위치한 비트를 **최상위 비트(MSB, Most Significant Bit)** 라고 부른다.

‘Least(최소)’라고 부르는 이유는 이 비트가 가장 작은 숫자 값을 표현하기 때문이다. 예를 들어, 3비트 이진수 `101`을 보면, 이는 10진수로 5를 의미한다. 오른쪽부터 차례로 1, 2, 4를 표현하므로, 오른쪽 끝의 비트일수록 더 작은 값을 표현한다. 그렇기 때문에 이 비트를 ‘최하위 비트(LSB)’라고 부른다. 반면 왼쪽 끝의 비트는 가장 큰 값을 표현하므로 ‘최상위 비트(MSB)’라 부른다.

데이터의 위치를 설명하면, 예를 들어 `[7:0]` 형태로 숫자를 정의한다면, 8비트의 이진 스트림이 만들어지며, 이는 7번 비트가 왼쪽, 0번 비트가 오른쪽에 위치한다는 의미이다. 왼쪽에 `7`을 둔 이유는, 왼쪽이 **최상위 비트(MSB)** 를 나타내기 때문이다. 반면 오른쪽의 0번 비트는 **최하위 비트(LSB)** 를 의미한다.
따라서 이런 형태로 신호를 정의하면, 전체 8비트를 가진 신호가 된다. 즉, `signal[7:0]`은 총 8비트의 데이터를 표현한다.

만약 각 비트에 접근하고 싶다면, `assign` 문이나 `always` 블록에서 특정 비트를 직접 접근할 수 있다. 예를 들어, `signal[3]`처럼 직접 인덱스를 지정하거나, 두 비트(`signal[6:5]`)를 한꺼번에 접근할 수도 있다.
어떤 데이터를 선언하려면, 반드시 이런 방식으로 전체 비트 크기를 명시해야 한다.

만약 16비트 데이터를 만들고자 한다면, `wire` 데이터 타입으로 `wire [15:0] x;` 형태로 정의해야 한다.
하지만 다른 방법도 있다. 즉, 식별자(identifier)를 벡터로 나열하는 방식이다.

예를 들어 `[15:0] A [0:2]`처럼 정의하면, `[15:0] A[0]`, `[15:0] A[1]`, `[15:0] A[2]`라는 세 개의 신호가 생기며, 각각을 배열처럼 접근할 수 있다.
이 배열형 신호는 각각의 벡터를 복제한 형태로, `A[1][6]`처럼 접근하면 `A[1]`의 6번째 비트를 의미한다.
즉, 이런 방식은 **벡터 배열(vector array)** 혹은 **변수 배열(variable array)** 의 정의를 뜻한다.

## Other Data Types – Parameters

다음으로 이해해야 할 개념은 **parameter(매개변수)** 이다.
모듈을 정의할 때는 `module` 키워드와 함께 모듈 이름을 작성하고, 그 뒤에 포트 정의가 따라온다.
그런데 **모듈 이름과 포트 정의 사이**에 파라미터 정의를 넣을 수 있다.
즉, 이후의 코드가 해당 파라미터를 참조하게 된다.

```sv
module pe_single_batch
#( parameter W_SLICE = 4,
   parameter I_WIDTH = 8,
   parameter I_CH = 1024,
   parameter ACC_WIDTH = $clog2(I_CH),
   parameter M_WIDTH = W_SLICE + I_WIDTH,
   parameter O_WIDTH = W_SLICE + I_WIDTH + ACC_WIDTH,
   parameter O_CH = 32
)
(
    input  wire i_clk,
    input  wire i_rstn,

    //act_controller
    //input wire [O_CH-1:0] i_pred,
    input  wire i_en,
    input  wire i_first,
    input  wire [I_WIDTH-1:0] i_ia,
    input  wire [W_SLICE-1:0] i_w [0:O_CH-1],

    output wire [O_WIDTH-1:0] o_out [0:O_CH-1]
);
...
```
```sv
pe_single_batch
pe_inst(
    .i_clk     (clk_core),
    .i_rstn    (resetn),
    .i_en      (pe_en_wire),
    .i_first   (pe_first_wire),
    .i_ia      (pe_ia_wire),
    .i_w       (pe_w_wire),
    //.i_w_is_msb(pe_w_is_msb_wire),
    .o_out     (pe_acc_out)
);
```
```sv
DW02_mult
#(.A_width(I_WIDTH), .B_width(W_SLICE))
mult_inst(
    .A        (i_ia),
    .B        (mult_in_w[och]),
    .TC       (1'b1),        // signed mult.
    .PRODUCT  (mult_out[och])
);
```
이 파라미터는 **인스턴스화(instantiation)** 과정에서 제어할 수 있다.
만약 파라미터를 한 번 정의하고, 인스턴스화 과정에서 따로 값을 변경하지 않는다면, 모듈은 Verilog 코드에 정의된 기본 파라미터 값을 그대로 사용한다.
하지만 인스턴스화 시점에 파라미터 값을 변경하고 싶다면, 인스턴스화 구문에서 직접 새로운 값을 지정할 수 있다.
이렇게 하면 하드웨어의 동작이 그 파라미터 값에 따라 달라지게 된다.


이처럼 파라미터를 이용할 수 있는 모듈 정의 방식을 사용하면, 코드를 훨씬 간결하게 만들 수 있다.
예를 들어, 2개의 덧셈기(adder)로 구성된 모듈이나 4개의 덧셈기로 구성된 모듈을 각각 따로 정의할 필요가 없다.
단지 하나의 **파라미터화된 가산기(adder)** 를 정의하고, 인스턴스화 시점에서 파라미터 값만 다르게 주면 된다.
즉, 같은 모듈을 여러 크기에 맞게 재활용할 수 있다.
이런 이유로, 파라미터화된 설계는 하드웨어 설계에서 매우 유용하다.
```sv
module modXor
  #(parameter size=8, delay=15)
(
  output [size-1:0] AXorB,
  input  [size-1:0] a,b
);

  assign #delay AXorB = a ^ b;
endmodule

module param;
  // declarations
  modXor a(a1,b1,c1);
  modXor #(4,5) b(a2,b2,c2);
endmodule
```
이것은 파라미터화된 모듈 정의의 또 다른 예시이다.
이 모듈에서는 `size = 8`, `delay = 15`로 정의되어 있다.
따라서 `delay` 값 15와 `size` 값 8은 이후 코드에서 파라미터로 사용된다.
`size`는 `A`, `B`, `A XOR B` 등의 비트 폭(bit width)을 지정하는 데 사용된다. 즉, 이들은 모두 8비트 신호이다.

하지만 인스턴스화할 때는 이 값들을 변경할 수 있다.
예를 들어, 모듈 인스턴스화 구문에서 `size = 4`, `delay = 5`로 지정하면, 해당 인스턴스에서는 4비트 신호가 사용되고, 지연(delay)은 5로 적용된다.
이처럼 인스턴스화 시점에서 파라미터를 조정함으로써, 하나의 모듈을 다양한 환경에 맞게 재사용할 수 있다.

```sv
// Verilog-95 Style vs Verilog-2001 Style

// Verilog-95
module modXor (AXorB, a, b);
  parameter size=8, delay=15;
  output [size-1:0] AXorB;
  input  [size-1:0] a,b;
  wire [size-1:0] #delay AXorB = a^b;
endmodule

module param;
  // declarations
  modXor a(a1,b1,c1);
  modXor #(4,5) b(a2,b2,c2);
endmodule

// Verilog-2001
module modXor (AXorB, a, b);
  parameter size=8, delay=15;
  output [size-1:0] AXorB;
  input  [size-1:0] a,b;
  wire [size-1:0] #delay AXorB = a^b;
endmodule

module param;
  // declarations
  modXor a(a1,b1,c1);
  modXor #(.size(4), .delay(5)) b(a2,b2,c2);
endmodule
```

하지만 이 모듈 정의에는 약간의 오류가 있다.
여기에서 `size`가 8로 정의되어 있기 때문에, `A XOR B`뿐만 아니라 `A`와 `B` 모두 8비트로 정의되어 있다.
그러나 인스턴스화 시점에서 `size = 4`로 변경하고 싶다면, `A1`, `B1`, `C1`, `A2`, `B2`, `C2` 등 신호들을 각각 4비트 크기로 다시 정의해야 한다.
이런 정의가 필요하다.
아마도 이 예시는 단순히 파라미터화된 모듈 인스턴스화를 보여주기 위한 테스트벤치 예시일 가능성이 있다.

즉, 이 코드는 단순히 `A1`, `B1`, `C1`, `A2`, `B2`, `C2`를 선언만 했지만, 실제로는 각각의 비트 폭을 파라미터에 맞게 정의해야 한다.
만약 모듈이 파라미터화된 인스턴스화를 사용하지 않는다면, `A1`, `B1`, `C1`은 8비트 신호가 되어야 한다.
하지만 이 예시에서는 4비트로 사용해야 하므로, 사용 시 주의해야 한다.
항상 **대상 신호의 비트 폭(bit width)** 을 일관되게 맞춰야 한다.

### localparam
```sv
localparam CONFIG_NONE   = 1'b0;
localparam CONFIG_RESET  = 1'b1;

localparam [1:0] WBC_NONE       = 2'd0;
localparam [1:0] WBC_RESET      = 2'd1;
localparam [1:0] WBC_RUN        = 2'd2;
localparam [1:0] WBC_ALWAYS_RUN = 2'd3;

localparam [1:0] SLC_NONE       = 2'd0;
localparam [1:0] SLC_RESET      = 2'd1;
localparam [1:0] SLC_RUN        = 2'd2;
localparam [1:0] SLC_ALWAYS_RUN = 2'd3;

localparam [1:0] SLC_WFXP_IAFP  = 2'd0;
localparam [1:0] SLC_WFP_IAFP   = 2'd1;
localparam [1:0] SLC_WFP_IAFXP  = 2'd2;
localparam [1:0] SLC_SOFTMAX    = 2'd3;

```
다른 형태로는 **local parameter(지역 파라미터)** 정의가 있다.
이는 모듈 내부에서만 사용되는 상수(constant)이다.
앞서 설명한 파라미터(parameter)는 인스턴스화 시점에서 값이 변경될 수 있었지만,
**local parameter** 는 오직 해당 모듈 내부에서만 사용되며, 외부에서 값을 변경할 수 없다.
즉, 외부 하드웨어가 이 값을 제어할 수 없고, 완전히 독립적인 내부 상수로 사용된다.

`localparam` 정의는 다음과 같이 작성할 수 있다.
이 값은 단순히 상수이므로 데이터 타입을 별도로 지정할 필요가 없다.
비트 폭(bit width)을 명시할 수도 있고, 단일 정수 값을 지정할 수도 있다.

## Vector Usage
```sv
reg [15:0] data;   // Vector register - MSB 15, LSB 0
data[6]     // Bit-select - bit 6
data[8:3]   // Part-select - six bits
data        // The entire vector
data[15:0]  // The entire vector
```
예를 들어, 16비트 레지스터형 데이터를 정의했다고 하자.
이때 `data[6]`처럼 접근하면, 전체 16비트 중 6번째 비트(0부터 시작하는 인덱스 기준)를 의미한다.
`data[8:3]`처럼 작성하면, 8번 비트부터 3번 비트까지의 구간을 선택하여 추출한다.
즉, **부분 선택(part-select)** 과 **비트 선택(bit-select)** 이 모두 가능하다.

전체 벡터를 접근하고 싶다면, 단순히 `data`라고만 작성해도 된다.
이는 전체 16비트 데이터 전체를 의미한다.

```sv
reg[7:0] signal_a;

initial begin
	signal_a= 8’d0;
	$display(“a: %b”, signal_a);
	signal_a[2] = 1’b1;
	$display(“a: %b”, signal_a);
	$display(“a[1]: %b”, signal_a[1]);
	$display(“a[2]: %b”, signal_a[2]);
end
```

이것은 하나의 예시이다.
이 코드는 `initial` 문을 사용하여 작성되었기 때문에, **테스트벤치(test bench)** 에서 사용될 수 있다.
`initial` 블록은 단순한 연결(assign)이 아니므로, 값을 바꾸기 위해서는 반드시 `reg` 데이터 타입을 사용해야 한다.

예를 들어 `signal A`가 `0`으로 초기화되었다면, 이는 `00000000`의 값을 가진다.
이 상태에서 출력을 확인하면 `A = 00000000`으로 표시된다(언더바 없이).
이때, 두 번째 비트(즉, `A[2]`)를 `1`로 변경하면 결과는 `00000100`이 된다.
이는 0번째, 1번째, 2번째 중 두 번째 위치에 `1`이 들어갔기 때문이다.

따라서 `A[1]`, `A[2]` 등 개별 비트 값을 직접 접근하거나 출력할 수 있다.

## 비트 단위 접근(bit addressing)
```sv
initial begin
	signal_a= 8’d0;
	$display(“a: %b”, signal_a);
	signal_a[2] = 1’b1;
	$display(“a: %b”, signal_a);
	$display(“a[1]: %b”, signal_a[1]);
	$display(“a[2]: %b”, signal_a[2]);
end
```
또한 **비트 단위 접근(bit addressing)** 도 가능하다.
이런 형식(`A[6]`, `A[3:1]` 등)을 이용하면 특정 비트나 비트 구간을 직접 읽거나 쓸 수 있다.

예를 들어, 초기 상태가 `00000000`인 신호에서, `A[3:1] = 3'b101`로 대입하면,
3, 2, 1번째 비트가 `1, 0, 1`로 바뀌면서 전체 출력은 `00001010`이 된다.
즉, `A[3] = 1`, `A[2] = 0`, `A[1] = 1`이 된다.
다른 나머지 비트는 기존 값을 그대로 유지한다.

따라서 `A[1] = 1`, `A[2] = 0`, `A[3] = 1`이 되며,
`A[4:1]`을 출력하면 결과는 `0101`로 나타난다.
즉, 지정된 비트 구간을 그대로 출력할 수 있다.

## Memory Addressing

변수 배열(variable array)이나 벡터 배열(vector array)을 정의하면, 이를 메모리처럼 접근할 수도 있다.
예를 들어 `reg [7:0] memory [0:3];`처럼 정의하면,
`memory[0]`, `memory[1]` 등 각 주소를 직접 접근할 수 있다.

또한, 특정 배열 원소의 일부 비트만 선택할 수도 있다.
예를 들어 `memory[1][3]`은 두 번째 줄(주소 1)의 세 번째 비트를 의미한다.
이와 같이, 배열의 특정 행(row)과 특정 비트(bit)를 동시에 선택할 수 있다.

## Implicit Data Type: Nets (wire)

이제 중요한 주의사항이다.
항상 **데이터 타입을 명시적으로 작성하라.**
만약 데이터 타입을 생략하면, Verilog는 기본적으로 **`wire` 타입**으로 인식한다.
그러나 이러한 암묵적 타입 지정은 혼란을 일으킬 수 있으므로,
항상 `wire`나 `reg`을 명시적으로 작성하는 것이 좋다.
즉, 데이터 타입을 생략하면 코드가 예상치 못한 방식으로 동작할 수 있다.

## Behavioral Modeling Example
이제 예시로 **행위적 모델링(behavioral modeling)** 을 살펴보자.
행위적 모델링은 `initial` 문이나 `always` 문을 이용하여 동작을 기술하는 방식이다.
즉, 회로의 구조가 아닌 **동작(behavior)** 을 코드로 표현하는 것이다.

여기서 중요한 점은 `initial` 문의 실제 의미이다.
`initial` 블록은 **단 한 번만 실행된다.**
즉, 시뮬레이션이 시작될 때 블록 내부의 코드가 한 번 실행되고 종료된다.
예를 들어,
```sv
module m16Behav(
    output reg [3:0] value,
    input  wire      clock,
    output reg       fifteen, altFifteen
);

initial
    value = 0; 

```
이 코드는 시뮬레이션 시작 시 한 번만 실행된다.

```sv
always @(negedge clock)  // conditions of execution
begin
    #10 value = value + 1;
    if (value == 15) begin
        altFifteen = 1;
        fifteen = 1;
    end
    else begin
        altFifteen = 0;
        fifteen = 0;
    end
end

endmodule
```
반면 `always` 문은 조건이 만족될 때마다 **반복적으로 실행된다.**
즉, `always` 블록은 특정 신호 변화에 반응하는 동작을 정의할 때 사용한다.
이것이 `always` 문의 핵심 개념이다.

## Behavioral Modeling

따라서 Verilog에서 동작을 기술하는 방법은 두 가지가 있다.

1. `always` 문 — 반복 실행되는 블록
2. `initial` 문 — 시뮬레이션 시작 시 한 번만 실행되는 블록

이 둘을 통틀어 **절차적 블록(procedural block)** 이라고 부른다.

### always
`always` 블록을 사용할 때는 **화살표(<=) 할당 연산자**를 사용해야 한다.
특히 클록 신호(`posedge clk` 등)에 동기화된 **순차 회로(sequential logic)** 를 설계할 때는 반드시 `<=`를 사용한다.
이 연산자는 **비차단(non-blocking)** 할당을 의미하며, 클록 엣지에서 동시에 갱신되는 신호를 표현할 때 필요하다.

### initial
반면, `initial` 블록이나 조합 논리(combinational logic)를 표현할 때는 **등호(=)** 를 사용한다.
즉,

* 조합 논리(`always @(*)`) -> `=` (blocking assignment)
* 순차 논리(`always @(posedge clk)`) -> `<=` (non-blocking assignment)
  로 구분하여 사용해야 한다.

클록에 의한 갱신이 포함될 경우 반드시 `<=`를 써야 한다.

물론, 클록 동기화 블록에서 `=`를 사용하더라도 문법 오류가 발생하지는 않는다.
하지만 이렇게 하면 블록의 실제 동작이 의도와 다르게 될 가능성이 크다.

아래 예시는 테스트벤치 설계에서 자주 사용하는 `initial` 블록 예시이다.
테스트벤치를 작성할 때는 변수를 정의할 때 **등호(`=`)** 를 사용해야 한다.
앞서 설명했듯, `=`는 **순차적 실행(blocking)** 을 의미한다.
즉, 한 줄의 코드가 실행된 후 그 다음 줄이 실행된다.

하지만 클록에 동기화된 회로, 즉 **순차 논리 회로(sequential circuit)** 를 표현할 때는
`=` 대신 반드시 **화살표(`<=`)** 를 사용해야 한다.
이것이 클록 기반 회로를 올바르게 표현하는 방법이다.

### if-else
행위적 모델링에서는 `if` 문과 `else` 문을 함께 사용할 수도 있다.
이는 C나 Python의 조건문과 동일하게 동작한다.
즉, 조건식이 참이면 해당 블록이 실행되고, 거짓이면 실행되지 않는다.

Verilog에서 조건식이 참인지 거짓인지는 **값이 0인지 아닌지**로 판단한다.
조건식의 결과가 `0`이면 **거짓(false)**,
그 외의 값(`1`, `2`, `3` 등)은 **참(true)** 으로 간주된다.

하지만 주의해야 할 점은, 조건문에서는 **단일 비트(single-bit)** 값을 사용하는 것이 좋다는 것이다.
예를 들어,

```sv
if (index > 0)
```

처럼 작성하면 결과가 1비트로 표현된다.
이 경우 `index > 0`의 결과는 `1`(참) 또는 `0`(거짓)만을 가진다.
멀티비트 값을 그대로 조건문에 사용하는 것은 바람직하지 않다.

예를 들어,

```sv
if (index)
```

라고만 쓰면 `index`가 여러 비트를 가질 수 있기 때문에 애매하다.
이럴 때는 반드시 비교 연산을 통해 1비트 결과로 만들어야 한다.
즉,

```sv
if (index != 0)
```

처럼 쓰는 것이 명확하고 안전하다.

조건문에는 `else` 구문도 존재한다.
만약 `if` 조건이 참이 아니라면, `else` 블록이 실행된다.

예를 들어, 다음 코드가 있다고 하자.

```verilog
if (index > 0) begin
    if (A > B) up = A;
    else up = B;
end
```

이 경우 `index`가 0보다 크면 내부 비교문이 실행되고,
`A`가 `B`보다 크면 `up`에 `A`가 저장되며, 그렇지 않으면 `B`가 저장된다.

하지만 위의 예시는 `index <= 0`인 경우를 고려하지 않았다.
따라서 그런 상황까지 포함하려면, `else` 블록을 추가로 작성해야 한다.
즉,

```verilog
else up = 0;
```

와 같이 기본 동작을 지정해야 한다.

단순히 `if` 문만 쓰는 경우와 `if-else` 문을 함께 사용하는 경우는 결과가 다를 수 있다.
예를 들어,

* `if`만 있는 경우 -> 조건이 거짓이면 아무 동작도 하지 않는다 (이전 값 유지).
* `if-else`를 함께 쓰는 경우 -> 조건이 거짓일 때 명시적으로 다른 동작을 수행한다.

따라서 회로의 상태 변화가 다르게 나타날 수 있으므로 주의해야 한다.

또 다른 방식으로 조건을 기술할 수 있는데, 바로 **`else if`** 문을 사용하는 것이다.
이는 C나 Python과 동일하게, 여러 조건을 순차적으로 검사할 때 사용된다.
즉,

```verilog
if (A > B) ...
else if (A == B) ...
else ...
```

형태로 작성한다.

많은 학생들이 `if-else` 대신 `case` 문을 사용하려 하지만,
`case` 문법에 익숙하지 않다면 오히려 오류를 일으키기 쉽다.
따라서 초보 단계에서는 `if-else` 구문을 사용하는 것이 더 안전하다.

### case

조건 분기(branching)를 구현하는 또 다른 방법은 **`case` 문**이다.
하지만 두 가지를 반드시 기억해야 한다.

1. `case` 문에서 값을 변경하는 출력 신호는 **반드시 `reg` 타입**으로 선언해야 한다.
2. Verilog에 아직 익숙하지 않다면, `case` 대신 `if-else` 구문을 사용하는 것이 좋다.


```verilog
case (A)
    2'b00: Y = 0;
    2'b01: Y = 1;
    ...
endcase
```

이 문법은 코드를 간결하게 만들고, 구조적으로 읽기 쉽다는 장점이 있다.
그러나 `default` 문을 생략하거나 잘못 작성하면, 합성 결과가 예기치 않게 달라질 수 있다.
즉, `case` 문은 강력하지만, **불완전한 기술은 위험하다.**

일부 엔지니어는 `default` 절을 생략하는데, 이는 매우 위험하다.
왜냐하면 입력이 어떤 값일 때도 해당되지 않으면 출력이 정의되지 않은 상태가 될 수 있기 때문이다.
따라서 `case` 문을 작성할 때는 항상 `default:` 절을 포함해야 한다.
이것이 안정적인 회로 합성을 위한 기본 규칙이다.

또한, **`casex` 문**이라는 확장 문법도 있다.
이는 입력 값 중 일부 비트가 ‘don't care’ 상태일 때(`x` 또는 `z`) 비교를 허용한다.
즉, `case` 문을 작성할 때 ‘무시할 비트’를 포함할 수 있는 형태이다.

예를 들어,

```verilog
casez (A)
    4'b1x00: Y = 1;
    default: Y = 0;
endcase
```

이처럼 특정 비트를 `x`로 표현하면, 그 위치의 값(0이든 1이든 상관없음)은 무시하고 비교한다.
하지만 여전히 `default` 절은 반드시 포함해야 한다.
그렇지 않으면 일부 입력 조합에서 회로가 정의되지 않은 상태에 빠질 수 있다.

예를 들어,
`case` 문에서 일부 입력 조합(`0110`, `0011` 등)이 어떤 항목에도 일치하지 않는다면,
해당 경우의 출력은 정의되지 않는다.
즉, 시뮬레이션 중에도 결과가 예측 불가능하고, 합성 시에도 도구가 임의의 값을 선택할 수 있다.
따라서 이런 상황을 피하기 위해 항상 **`default`** 를 지정해야 한다.

합성기(synthesis tool)는 이러한 누락된 경우를 자동으로 감지하지만,
그 이후의 동작은 합성 옵션이나 최적화 설정에 따라 달라질 수 있다.
즉, 결과 회로의 동작이 예측 불가능해진다.
따라서 `default` 절을 생략하면, **불안정하고 예측할 수 없는 하드웨어** 가 생성될 수 있다.
이 점은 매우 중요하다.

따라서 `case` 문을 사용할 때 기억해야 할 핵심 규칙은 다음과 같다.

1. `case` 문에 의해 값이 변경되는 출력 신호는 반드시 **`reg` 타입**이어야 한다.
2. 반면, `case` 문에 사용되는 입력 신호는 **`wire` 타입**으로 선언해도 된다.

즉,
```verilog
reg [3:0] out;
wire [1:0] sel;
case (sel)
   2'b00: out = 4'b0001;
   2'b01: out = 4'b0010;
   ...
endcase
```

이런 구조가 올바른 형태이다.

많은 사람들이 혼동하는 또 다른 부분은,
**`case` 문은 반드시 행위적 블록(behavioral block)** 내부에 작성되어야 한다는 점이다.
즉, `case` 문은 보통 `always` 블록 안에 포함되어야 한다.
(`always` 또는 `initial` 블록 밖에서 사용할 수 없다.)

일반적으로 `case` 문은 클록 신호와 동기화되지 않은 상태로 사용된다.
즉, `always @(*)` 블록 내부에서 사용될 때, **조합 논리 회로(combinational logic)** 를 표현한다.
만약 `posedge clk` 등의 클록 조건이 포함되지 않았다면,
그 `case` 문은 순차 회로가 아니라 조합 회로를 정의하는 것이다.

따라서 `case` 문이 어떤 블록 안에 있는지에 따라 회로의 성질이 달라진다.

## Prime number Example

다음은 또 다른 `case` 문 예시이다.
출력 신호는 `case` 문에 의해 결정되므로 반드시 `reg` 타입으로 선언되어 있다.
입력 값이 바뀔 때마다 `case` 블록이 다시 실행되어,
해당 조건에 맞는 출력 값이 갱신된다.

```sv
//--------------------------------------------------------------
// prime
// in       - 4 bit binary number
// isprime  - true if "in" is a prime number 1,2,3,5,7,11, or 13
//--------------------------------------------------------------
module prime(in, isprime);
    input  [3:0] in;       // 4-bit input
    output        isprime; // true if input is prime
    reg           isprime;

    always @(in) begin
        case (in)
            1,2,3,5,7,11,13: isprime = 1'b1;
            default:          isprime = 1'b0;
        endcase
    end
endmodule

```
예를 들어 입력 값이 `1`, `2`, `3`, `5`, `7`, `11`, `13`일 때,
출력 `isprime`은 1로 설정된다.
그 외의 값에서는 0으로 설정된다.
즉, 입력이 소수(prime number)일 때만 출력이 1이 된다.

```sv
module prime1(in, isprime);
    input  [3:0] in;       // 4-bit input
    output        isprime; // true if input is prime
    reg           isprime;

    always @(*) begin
        casex (in)
            4'b0xx1: isprime = 1;
            4'b001x: isprime = 1;
            4'bx011: isprime = 1;
            4'bx101: isprime = 1;
            default: isprime = 0;
        endcase
    end
endmodule

```
이 기능은 `casex` 문을 이용해 더 간단히 표현할 수도 있다.
`casex`는 일부 입력 비트를 무시(don’t care)할 수 있으므로,
입력 조합이 많을 때 효과적이다.
예를 들어 입력 진리표가 0부터 15까지 있다면,
소수에 해당하는 입력(1, 2, 3, 5, 7, 11, 13)만 1로 설정하고 나머지는 0으로 처리할 수 있다.

예를 들어,
`4'b0xx1`과 같이 작성하면, `0001`, `0011`, `0101`, `0111` 등 여러 입력 조합을 한 번에 표현할 수 있다.
이 값들은 각각 1, 3, 5, 7을 의미하며, 모두 소수이다.
따라서 `case x` 문을 사용하면 여러 경우를 하나의 패턴으로 묶을 수 있다.

예를 들어 `4'b001x`는 `0010`(2), `0011`(3)을 모두 포함하므로, 두 경우 모두 출력은 1이 된다.
또한 `4'bx101`은 `0101`(5), `1101`(13)을 모두 포함하므로,
이들 역시 소수로 처리할 수 있다.
그 외의 모든 경우에는 출력이 0이 된다.

이런 패턴을 기반으로 **진리표(truth table)** 를 만들고,
**논리 최소화(logic minimization)** 를 수행하면,
최종적으로 단순화된 논리식(예: SOP/POS)을 얻을 수 있다.

`case x` 문을 사용하면 특정 입력 패턴을 더 간단히 표현할 수 있다.
이때 `always` 블록의 감지 조건에서 `@(*)` 또는 `@ (in)`처럼 작성할 수 있으며,
보통 `@(*)`는 모든 입력 변화에 반응하는 **조합 논리 회로**를 의미한다.

또한 중요한 점은, `always` 블록을 조합 논리용으로 사용할 때는 **비차단(`<=`)** 대신 **차단(`=`)** 할당을 사용해야 한다는 것이다.
왜냐하면 이 블록은 클록에 동기화되지 않았기 때문이다.
즉,이런 형태에서는 `=`를 사용해야 올바른 조합 회로가 생성된다.

소수를 판별하는 또 다른 방법은 `assign` 문을 이용한 조합 논리식으로 작성하는 것이다.
즉,
```sv
module prime2(in, isprime);
    input  [3:0] in;       // 4-bit input
    output        isprime; // true if input is prime

    wire isprime = (in[0] & ~in[3]) |
                   (in[1] & ~in[2] & ~in[3]) |
                   (in[0] & ~in[1] & in[2]) |
                   (in[0] & in[1] & ~in[2]);
endmodule
```
이런 방식으로 논리식을 직접 기술하면,
조합 논리 형태로 소수 판별 기능을 구현할 수 있다.
이는 논리 최소화 과정을 통해 얻은 결과를 그대로 회로로 표현한 것이다.

세 가지 방법(`case`, `case x`, `assign`) 중에서,
초보자에게는 **`assign` 문을 이용한 조합 논리 표현 방식**을 추천한다.
이 방식은 메모리 요소에 의존하지 않으며, 클록 동기화가 필요 없는 단순한 회로이기 때문이다.
따라서 하드웨어 동작을 명확하게 표현할 수 있다.

반면 Verilog에 충분히 익숙해진다면,
`case` 문을 사용하여 코드를 더 간결하게 작성할 수 있다.
이 방법은 복잡한 조건을 구조적으로 표현할 때 유용하다.

이제 이 소수 판별 모듈을 **테스트하기 위한 테스트벤치(testbench)** 를 작성해야 한다.
테스트벤치에서는 실제 하드웨어 입출력 포트를 정의하지 않는다.
대신, 입력 신호는 **`reg` 타입 변수**로 선언하고,
`initial` 블록 안에서 값을 순차적으로 변경하여 테스트를 수행한다.

```sv
module test_prime;
    // declare local variables
    reg  [3:0] in;
    wire       isprime;

    // instantiate module under test
    prime p0(in, isprime);

    initial begin
        // apply all 16 possible input combinations to module
        in = 0; // set input to initial value
        repeat (16) begin
            #100; // delay for 100 time units
            $display("in = %2d  isprime = %1b", in, isprime);
            in = in + 1; // increment input
        end
    end
endmodule
```
예를 들어, 입력을 0부터 15까지 변화시키며 16회 반복하고,
각 반복마다 100 단위 시간(`#100`)을 기다린 뒤,
현재 입력 값과 모듈의 출력 결과를 화면에 출력한다.

즉, 시뮬레이션에서 입력을 자동으로 변화시키고, 그에 따른 결과를 관찰한다.

이제 출력 결과를 분석해보자.
시뮬레이션이 시작되면 `initial` 블록의 첫 번째 코드가 실행된다.
처음 입력은 4비트 값 `0000`(즉, 0)이며, 이 값이 모듈의 입력으로 들어간다.
0은 소수가 아니므로 출력은 0이 된다.

하지만 출력(`$display`)은 즉시 나타나지 않는다.
이는 코드가 `#100` 지연 후에 반복되도록 작성되어 있기 때문이다.
즉, 100 단위 시간이 지난 뒤에야 `display` 함수가 실행되어 결과가 출력된다.

그 후 입력 값이 1 증가(`in = in + 1`)하여 `0001`이 된다.
이 값은 소수이므로 출력이 1로 바뀐다.
그러나 역시 출력은 즉시 보이지 않고, 100 단위 시간이 지난 후 표시된다.
이러한 과정을 반복하여 입력 0~15의 모든 경우를 테스트한다.

이후 입력이 2(`0010`), 3(`0011`) 등으로 증가하면서,
각각의 입력에 대해 100 단위 시간 간격으로 출력이 표시된다.
소수인 입력의 경우 출력이 1로, 그 외에는 0으로 출력된다.

만약 코드의 실행 순서를 바꾼다면, 출력 결과가 달라질 수 있다.
예를 들어 `display` 문이 `in = in + 1` 이후에 위치하면,
출력되는 값은 이전 입력이 아닌, 증가된 입력의 결과가 된다.
즉, 문장의 순서에 따라 시뮬레이션 출력 타이밍이 달라진다.
따라서 테스트벤치를 작성할 때는 실행 순서에 주의해야 한다.

```sv
// Instantiate two separate modules and compare their outputs
// ==, != and ===, !==
module test_prime1;
    reg  [3:0] in;
    reg        check;     // set to 1 on mismatch
    wire       isprime0, isprime1;

    // instantiate both implementations
    prime  p0(in, isprime0);
    prime1 p1(in, isprime1);

    initial begin
        in = 0; check = 0;
        repeat (16) begin
            #100;
            if (isprime0 !== isprime1) check = 1;
            in = in + 1;
        end
        if (check != 1) $display("PASS");
        else            $display("FAIL");
    end
endmodule
```
다음은 **자가 검증(Self-checking)** 테스트벤치의 예시이다.
같은 기능을 수행하는 두 개의 모듈(예: 원본 모듈과 개선된 모듈)을 동시에 시뮬레이션하여,
각각의 출력을 비교함으로써 기능이 동일한지 자동으로 검증한다.
이 방식은 회로의 기능 검증을 자동화할 때 유용하다.

이런 방식으로, 두 번째 모듈이 첫 번째 모듈과 동일하게 동작하는지를 확인할 수 있다.
즉, 두 구현 간의 논리적 일치성을 검증하는 것이다.

## Thermometer Code Example

다음 예시는 **Thermometer Code** 회로이다.
예를 들어, 4비트 입력이 다음과 같은 값을 가진다고 하자:
`0000`, `0001`, `0011`, `0111`, `1111`
이 경우 출력이 1이 되며, 그 외의 입력 조합에서는 출력이 0이 된다.

이 패턴은 ‘온도가 올라갈수록 1의 개수가 늘어나는’ 형태를 가지므로,
마치 온도계(thermometer)처럼 동작한다고 해서 **Thermometer Code** 라고 부른다.


```sv
// with case
module therm_case(in, out);
    input  [3:0] in;
    output       out;
    reg          out;

    always @(*) begin
        case (in)
            0, 1, 3, 7, 15: out = 1'b1;
            default:        out = 1'b0;
        endcase
    end
endmodule
```
이 회로는 `case` 문을 이용해 기술할 수 있다.
이를 구현할 때 `case` 문은 반드시 `always` 블록 안에 포함되어야 한다.
입력 신호는 `reg` 또는 `wire` 타입 모두 가능하지만,
모듈의 `input` 포트로 선언된 신호는 기본적으로 `wire` 타입으로 간주된다.

반면, `case` 문에서 출력 값을 변경하려면 해당 신호는 반드시 `reg` 타입으로 선언해야 한다.
또한 `default` 절을 반드시 포함해야 한다.

```sv
// with casex
module therm_casex(in, out);
    input  [3:0] in;
    output       out;
    reg          out;

    always @(*) begin
        casex (in)
            4'b000x: out = 1;
            4'b0011: out = 1;
            4'bx111: out = 1;
            default: out = 0;
        endcase
    end
endmodule
```
이 코드는 `case x` 문을 이용하면 더욱 간단하게 표현할 수 있다.
왜냐하면 특정 비트(MSB 등)는 결과에 영향을 주지 않기 때문에,
이를 ‘don’t care’로 처리하여 조건을 줄일 수 있기 때문이다.

```sv
// with assign
module therm_assign(in, out);
    input  [3:0] in;
    output       out;

    assign out = (~in[3] & ~in[2] & ~in[1]) |
                 (~in[3] & ~in[2] & in[1] & in[0]) |
                 (in[2] & in[1] & in[0]);
endmodule
```
또한, 진리표를 기반으로 **논리 최소화(logic minimization)** 를 수행하면,
이 회로를 더 단순한 조합 논리 형태로 변환할 수 있다.
이때 최종 회로는 `assign` 문을 사용해 정의할 수 있다.

```sv
module therm_test;
    reg  [3:0] in;
    reg        check;
    wire       t0, t1, t2, t3;

    therm_assign m0(in, t0);
    therm_case   m1(in, t1);
    therm_casex  m2(in, t2);
    therm_struct m3(in, t3);

    initial begin
        in = 0;
        check = 0;
        repeat (16) begin
            #100;
            $display("in = %4b  therm = %1b", in, t0);
            if (t0 !== t1) check = 1;
            if (t0 !== t2) check = 1;
            if (t0 !== t3) check = 1;
            in = in + 1;
        end
        if (check != 1)
            $display("PASS");
        else
            $display("FAIL");
    end
endmodule // therm_test
```
이것은 **Thermometer Code 회로용 테스트벤치** 이다.
이전의 소수 판별 예시와 동일하게, 입력을 순차적으로 변화시키며 출력을 확인한다.
각 출력(`T0`, `T1`, `T2`, `T3`)이 예상값과 동일한지 검사하고,
모든 테스트가 통과하면 “PASS” 메시지를 출력한다.

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>
<script type="text/x-mathjax-config"> MathJax.Hub.Config({ tex2jax: {inlineMath: [['$', '$']]}, messageStyle: "none" });</script>