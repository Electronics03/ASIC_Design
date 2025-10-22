# ASIC 설계의 이해 2
## 전원 공급
이제 논리 회로(logic side)에 대해 자세히 살펴보자.
앞서 언급했듯이, 칩에 전원을 공급하기 위해서는

* VDDIO 패드는 IO 전압(예: 1.8V)을 공급하고,
* VDD 패드는 버퍼(buffer)와 레벨 시프터(level shifter)에 저전압(예: 1.0V)을 공급하며,
* GND(VSS) 패드는 회로 전체의 기준 전위(ground)를 설정한다.
  또한 신호 패드(signal pad)는 데이터 통신(data communication)을 위해 사용된다.

그러나 이러한 패드들은 칩 가장자리 주변에만 배치되어 있다.
그렇다면 칩 내부의 CMOS 로직 회로에는 어떻게 전압이나 전류를 공급할 수 있을까?

그 핵심은 다음과 같다.
앞서 말했듯이, VDDIO는 1.8V 정도의 고전압이므로 내부 로직에 그대로 전달할 필요는 없다.
내부 회로에는 일반적으로 1.0V 수준의 VDD만 공급하면 된다.
따라서 이 1.0V 전압이 칩 내부의 로직 셀에 전달되어야 한다.

이를 실현하는 가장 단순한 방법은 다음과 같다.
먼저 칩 내부에 로직 블록(logic area)이 있다고 가정하자.
그 주변을 따라 금속 전원 링(metal power ring)을 배치한다.
그리고 VDD 패드를 VDD 전원 링에,
GND 패드를 그라운드 전원 링에 각각 연결한다.
그 후, 내부의 로직 셀이 전력이 필요할 경우,
추가적인 금속 배선(metal routing)을 통해 셀을 VDD 또는 GND에 연결한다.

즉, 전원을 공급하기 위해 가장 먼저 해야 할 일은
로직 영역 주위를 따라 두꺼운 파워 링(power ring)을 형성하는 것이다.

이것이 중요한 이유는 다음과 같다.
로직 셀이 특정 위치에 배치되어 있을 때,
그 셀은 인접한 파워 링으로부터 VDD를 공급받고,
인접한 그라운드 링으로부터 GND를 전달받을 수 있기 때문이다.
즉, CMOS 로직 회로는 기본적으로 VDD와 GND에 연결되어야 하지만,
이러한 전원 링 구조를 통해 간접적으로 안정적인 전력 공급이 가능하다.

## Standard Cell

이제 표준 셀(standard cell)의 정의를 살펴보자.
앞서 언급했듯이, 표준 셀은 기본적으로 CMOS 로직 회로이다.
프론트엔드(front-end) 설계 단계에서, 우리가 Verilog 같은 하드웨어 기술 언어로 코드를 작성하면
그 결과는 게이트 레벨 넷리스트(gate-level netlist)로 변환된다.
이때 변환된 각각의 단일 모듈이 바로 표준 셀의 정의가 된다.

그렇다면 표준 셀의 구체적인 정의는 무엇일까?
표준 셀은 불린 논리(Boolean logic) 기능이나 저장 기능(storage function)을 수행하기 위해
트랜지스터와 배선(interconnect)으로 구성된 하나의 기본 회로 블록이다.

즉, 표준 셀은 트랜지스터와 금속 배선의 단순한 조합으로,
논리 연산(logic operation)을 수행하거나 플립플롭(D-FF) 또는 래치(latch) 같은 저장 기능을 구현한다.
따라서 하나의 표준 셀은 단일 동작 모듈(single operation module)로 간주할 수 있다.

물론 경우에 따라 표준 셀에는 더 복잡한 회로,
예를 들어 전가산기(full adder)나 반가산기(half adder) 같은 구조가 포함될 수도 있다.
이러한 복잡한 회로는 더 작은 레이아웃 면적으로 최적화될 수 있기 때문이다.

또한, 표준 셀은 라이브러리 기반(library-based) 회로와 밀접한 관련이 있다.
즉, 각 셀의 회로도(schematic)와 레이아웃(layout)이 미리 정의되어 있으며,
이 정의된 셀들이 프론트엔드(front-end)나 백엔드(back-end) 설계 과정에서 그대로 활용된다.

예를 들어 NAND 게이트를 살펴보면, 그 형태와 레이아웃 구조가 이미 표준 셀 라이브러리에 정의되어 있다.
마찬가지로 인버터(inverter)를 설계할 때도, 그 레이아웃은 회로 설계자(layout engineer)에 의해 미리 정의되어 있다.

즉, 사용자가 Verilog 코드(또는 하드웨어 기술 언어)를 작성하고 합성(synthesis)을 수행하면,
그 결과로 프로그램은 여러 개의 표준 셀 조합(standard cell combination) 형태로 변환된다.
이러한 변환 결과를 담은 파일을 우리는 게이트 레벨 넷리스트(gate-level netlist)라고 부른다.
표준 셀 라이브러리에는 다음과 같은 다양한 회로들이 포함된다.

* 인버터(Inverter)
* 버퍼(Buffer), 트라이스테이트 버퍼(Tri-state buffer)
* AND, NAND, NOR 게이트
* 멀티플렉서(Multiplexer)
* 반가산기(Half Adder), 전가산기(Full Adder)
* D 플립플롭(D-Flip Flop) 등
  이 모든 회로들이 표준 셀 라이브러리(standard cell library)에 정의되어 있다.

이 다이어그램이 의미하는 것은 레이아웃(layout)이다.
즉, 검은색 사각형은 금속 배선(metal layer)의 위치를 나타내고,
파란색 영역은 도핑(doping)이 이루어진 부분을 의미한다.
빈 공간이나 회색 영역은 n형 반도체 영역(n-type region) 또는 p형 영역(p-type region)을 나타내며,
또한 그림에는 비아(via)의 정보도 포함되어 있다.
따라서 이 도면은 CMOS 로직 회로의 구조, 즉 NMOS와 PMOS 트랜지스터가 포함된 실제 배치 형태를 보여준다.

> MOSFET이라는 용어를 살펴보면, 이름에 Metal-Oxide라는 표현이 들어 있다.
따라서 금속층(metal layer)과 산화막(oxide)은 MOSFET의 정의와 밀접한 관련이 있다.
그러나 실제로는 현대의 MOSFET은 금속 게이트를 포함하지 않는다.
대신, 금속 대신 폴리실리콘(polysilicon)이 게이트 물질로 사용된다.
그 이유는 금속이 열에 매우 민감하기 때문이다.
즉, 높은 온도에 노출되면 금속의 팽창 계수(coefficient of expansion)가 커지고,
이로 인해 MOSFET의 전기적 특성이 온도에 따라 변화할 수 있다.
따라서 임계전압(threshold voltage)의 안정적 제어와 열 특성(thermal stability)을 위해
폴리실리콘 게이트가 사용된다.
또한 폴리실리콘은 금속처럼 완전한 도체는 아니며, 전압을 전달하면서도 절연 특성을 일부 유지하기 때문에
MOSFET의 전기적 제어(electrical control)에 더 유리하다.
또한 폴리실리콘은 실리콘 공정(silicon process)과의 호환성이 뛰어나며,
금속 대신 폴리실리콘을 사용하면 MOSFET 크기 축소(scaling down)도 훨씬 용이하다.
게다가 금속을 사용하는 것보다 제조 비용도 훨씬 저렴하다.
따라서 오늘날 대부분의 MOSFET은 금속 게이트를 사용하지 않고, 폴리실리콘 기반 게이트 구조를 사용한다.

## multi-layer metal routing

그렇다면 배선(wire)은 어떨까?
배선은 일반적으로 구리(Cu) 또는 알루미늄(Al)을 이용해 형성된 금속층(metal layer)으로 설계된다.

그런데 만약 금속층이 단 한 층(single layer metal)만 존재한다면 어떻게 될까?
하나의 금속 배선만으로 회로를 구성할 경우,
서로 다른 노드(node)들을 연결할 때 배선 간격(minimum spacing)을 유지하기 어렵고,
교차 배선이 불가능하기 때문에 레이아웃 오류(layout violation)가 발생할 수 있다.

결국, 인접한 금속 배선이 존재할 경우에는 한쪽 배선을 위층으로 올려 연결해야 한다.
즉, 단일 금속층(single-layer routing)만으로는 교차를 피할 수 없기 때문에
이 방식은 실제 칩 설계에 비효율적이다.

한 층의 금속이 배치되면, 그 위를 다른 금속 배선이 교차하거나 통과할 수 없다.
즉, 단일 금속층에서는 물리적으로 배선이 서로 간섭(intersect)하여 연결 제약이 생기게 된다.

따라서 두 포트를 직접 연결하려 해도, 다른 금속 배선이 경로를 막고 있으면 연결이 불가능하다.
이 문제를 해결하기 위해 배선을 회로 바깥으로 우회시켜 연결할 수도 있지만,
이 경우 배선 길이가 길어지고, 자기장(magnetic field)이 유도되며,
면적 효율(area efficiency)과 전송 지연(latency) 측면에서도 불리하다.

이러한 문제를 해결하기 위해 다층 금속 배선(multi-layer metal routing)을 사용한다.
즉, 배선은 여러 층(floor)으로 구성되며, 각 층에는 하나의 금속층(M1, M2, M3, M4, M5)만 배치된다.
예를 들어, 이 설계에서는 총 5층의 금속층으로 배선을 구성한다고 가정할 수 있다.

### VIA

그렇다면 서로 다른 층(M1과 M2 등)에 위치한 배선을 어떻게 연결할까?
이를 위해 사용하는 개념이 바로 비아(VIA)이다.

비아(VIA)의 개념은 서로 다른 층에 존재하는 금속 배선을 전기적으로 연결하는 구조이다.
예를 들어, M1 층에 있는 배선과 M2 층의 배선을 연결하려면
두 금속층 사이에 비아(VIA)라는 전도성 구멍(conductive plug)을 삽입해야 한다.
즉, M1과 M2를 연결하는 추가적인 연결 소자(component)가 필요하며,
이것이 바로 비아(VIA)이다.

### 배선 방향(direction)이 고정

다층 금속 구조의 또 다른 특징은 각 금속층의 배선 방향(direction)이 고정되어 있다는 점이다.
예를 들어, M1 층은 수직(vertical) 방향 배선으로 사용되고,
그 위층인 M2 층은 수평(horizontal) 방향 배선으로 사용되는 식이다.

그보다 상위층인 M3, M4 층은 다시 수직 방향으로 배치된다.
이처럼 층별 배선 방향을 번갈아가며 설정하면,
배선 혼잡(congestion)을 줄일 수 있고,
자동 배선 도구(automatic router)가 적용되기 쉬운 일관된 설계 규칙(routing rule)을 만들 수 있다.

다만, 예외적으로 M1 층의 작은 영역(small area)에서는
필요에 따라 배선 방향을 반대로 설정할 수도 있다.

그러나 이런 예외적인 경우를 제외하고, 멀리 떨어진 포트(port) 간의 연결을 설계할 때는
각 금속층의 배선 방향 규칙은 고정되어 있으며 변경되지 않는다.
예를 들어, M7과 M8 같은 서로 다른 금속층을 연결할 때는
서로 다른 층을 이어주는 비아(VIA)를 사용한다.

### e.g. Inverter

이제 인버터(inverter)의 예를 살펴보자.
인버터의 회로도(schematic)는 다음과 같은 형태를 가진다.

여기서 NMOS 트랜지스터는 다음과 같은 심볼(symbol)로 표현되고,
PMOS 트랜지스터는 이에 대응하는 다른 심볼로 표현된다.
그 이유를 살펴보면, NMOS의 게이트 전압이 높을 때(high voltage) 트랜지스터가 켜진다(turn on).

반대로 게이트 전압이 낮을 경우, NMOS는 꺼진 상태(turn off)가 된다.
PMOS는 이와 정반대의 특성을 가진다.
즉, 게이트 전압이 낮으면 켜지고(turn on), 게이트 전압이 높으면 꺼진다(turn off).
이 특성 때문에, 마치 PMOS의 입력에는 논리 반전(inversion)이 한 번 적용된 것처럼 보인다.
그래서 회로 기호에서는 PMOS의 게이트 입력에 작은 원(bubble)이 붙는다.
이 버블 기호는 반전 동작을 나타내는 논리적 표현으로,
PMOS의 회로도에서도 이러한 심볼을 그대로 사용한다.

따라서 인버터 회로는 다음과 같이 단순화하여 표현할 수 있다.
입력(input)과 출력(output)이 존재하고,
출력은 VDD와 GND 사이의 전류 경로를 통해 형성된다.
이러한 심볼(symbolic representation)은 인버터의 회로도 표현(schematic representation)으로 자주 사용된다.

이 인버터는 실제로 물리적 구조(layout)로도 구현될 수 있다.
이때 NMOS와 PMOS의 게이트 단자(gate terminal)는 반드시 서로 공유되어 연결되어야 한다.
인버터의 실제 구현은 다음과 같은 3차원 단면도(3D cross-section)로 표현된다.
이 그림은 인버터의 물리적인 층 구조(layer stack)를 보여준다.

## Layout

그러나 이러한 3차원 단면 표현 방식은
인버터의 레이아웃 구조를 설명하기에는 비효율적이다.
그래서 실제 설계에서는 2차원 레이아웃(layout) 표현을 채택한다.
즉, 스케매틱(schematic)은 논리적 연결을,
레이아웃(layout)은 물리적 배치를 각각 나타낸다.

레이아웃에서는 P형 기판(P-substrate) 위에 N형 웰(N-well) 영역을 정의한다.
이 N형 영역 위에는 게이트 절연막(oxide layer)과 폴리 게이트(poly gate)가 형성되며,
소스(source)와 드레인(drain)이 각각 도핑되어 있다.
그 위에는 금속 배선(metal)이 배치되어 전기적 연결을 형성한다.

이러한 레이아웃 다이어그램은 인버터 회로의 구조와 배치 특성을 효율적으로 표현한다.
즉, 회로의 물리적 형태와 기능적 특성을 함께 시각적으로 나타내는 가장 실용적인 방법이다.
따라서 이러한 도면을 레이아웃(layout)이라고 부른다.
반면, 물리적 배치나 제조 공정을 고려하지 않고 논리적 동작만 설계할 때는,
스케매틱(schematic) 표현을 사용하는 것이 일반적이다.

이제 질문은 “작성한 코드를 어떻게 표준 셀(standard cell)로 변환할 수 있을까?”이다.
그 핵심은 앞선 강의에서도 언급했듯이 합성(synthesis) 과정에 있다.

## Synthesis
합성을 수행하려면 먼저 Verilog로 작성된 코드가 필요하다.
이러한 Verilog 설계는 레지스터 전이 수준(Register Transfer Level, RTL) 프로그래밍이라 부른다.
RTL 설계를 통해 디지털 회로를 조합 논리(combinational logic)와 순차 논리(sequential logic)로 표현할 수 있다.

RTL 설계는 단순히 레지스터(Register)뿐 아니라 논리 연산(logical operation)도 기술할 수 있다.
이러한 설계에는 주로 Verilog, VHDL, 그리고 SystemVerilog와 같은
하드웨어 기술 언어(HDL; Hardware Description Language)가 사용된다.
이번 강의에서는 Verilog를 중심으로 학습하겠지만,
일부 문법은 SystemVerilog의 확장 문법을 함께 사용할 수도 있다.

그렇다면 합성은 어떻게 수행되는가?
합성(synthesis)의 역할은 RTL 코드(Verilog 등)를 표준 셀 조합으로 변환하는 것이다.
즉, Verilog 코드를 합성하면 그 결과로 게이트 레벨 넷리스트(gate-level netlist)가 생성된다.

합성 과정은 사용하는 EDA(Electronic Design Automation) 툴에 따라 달라진다.
예를 들어,
* Synopsys사의 경우: Design Compiler를 사용하고,
* Cadence사의 경우: Genus 툴을 사용한다.

그렇다면, 게이트 레벨 넷리스트(gate-level netlist)를
실제 물리적 레이아웃(physical layout)으로 변환하려면 어떻게 해야 할까?
이 과정을 배치 및 배선(place and route, PnR)이라 부르며,
이 또한 사용하는 EDA 툴에 따라 달라진다.
즉, Verilog 코드가 표준 셀 조합으로 변환되어
게이트 레벨 넷리스트가 생성되면,
EDA 툴(예: Synopsys IC Compiler, Cadence Innovus)은
이 넷리스트와 함께 PDK(Process Design Kit) 정보를 입력받아
칩의 최종 레이아웃(physical layout)을 생성한다.

따라서 이 과정에서는
* 표준 셀의 배치(placement)를 수행하고,
* 셀 간 배선(routing)을 자동으로 관리한다.
  최종적으로 각 표준 셀은 속도(speed), 전력(power) 등의 최적화를 고려해 배치되며,
  셀 간의 연결은 라우팅(routing) 과정을 통해 정의된다.

## Standard Cell의 일정한 높이?

그런데 표준 셀의 레이아웃을 자세히 보면, 한 가지 중요한 특징이 있다.
바로 모든 표준 셀의 높이(height)는 일정하게 고정되어 있다.
이는 흥미로운 점이다.
왜냐하면 회로에 따라 논리 게이트 수나 배선 복잡도가 달라지므로
필요한 면적(area)은 커지거나 작아질 수 있기 때문이다.

하지만 표준 셀들은 가로 폭(width)은 다를 수 있어도,
세로 높이(height)는 반드시 동일하게 유지되어야 한다.
그렇다면 왜 모든 표준 셀이 고정된 높이(fixed height)를 가져야 할까?

또한 표준 셀의 가로 폭(width)은 항상 최소 단위 폭(W)의 정수배(integer multiple)로 정의된다.
예를 들어, 가장 작은 셀의 폭을 1W라 하면,
그보다 큰 셀은 2W, 3W, 4W 등과 같이 정수배 형태로만 존재한다.
즉, 모든 셀의 폭은 주어진 최소 폭을 기준으로 한 정수배 크기로 설정된다.
또 다른 표준 셀의 특징은,
물리적 정보(layout description)뿐만 아니라
회로 정보(circuit description)와 논리 기능 정보(functional description)도 함께 포함하고 있다는 점이다.
즉, 각 표준 셀은 Verilog 문법 기반의 기능 정의와 더불어
SPICE 회로 특성(spice data), 전력 소비(power), 기생 커패시턴스(capacitance),
전송 지연(delay), 천이 응답(transient response) 등의 정보가
라이브러리 데이터(library file) 안에 함께 포함되어 있다.

그렇다면 왜 표준 셀이 고정된 높이와 정수배 폭 구조를 가져야 할까?
그 이유는 전원 공급(power delivery)을 용이하게 하기 위해서이다.
앞서 언급했듯이, 배치 및 배선(place & route) 과정에서
표준 셀은 특정 위치에 배치된다.
이때 각 셀은 VDD와 GND로부터 전원을 공급받아야 하므로,
모든 표준 셀은 반드시 VDD와 GND 레일(rail)에 연결되어야 한다.

그러나 셀마다 임의로 VDD나 GND를 연결하면,
전원망의 길이와 경로가 복잡해지고,
그로 인해 전력 전달 효율(power delivery efficiency)을 예측하거나
전원 해석(power simulation)을 수행하기 어려워진다.

## PG rail

따라서 우리는 전원을 체계적으로 공급하기 위해
파워–그라운드 레일(PG rail, Power/Ground rail) 구조를 만든다.
즉, 저층 금속층(low-level metal)에
VDD 레일과 GND 레일을 반복적으로 배치하여
각 셀이 일정한 간격으로 전원을 받을 수 있도록 설계한다.

이러한 PG 레일 패턴은 칩 전체 영역에 걸쳐 반복된다.
그중 VDD 레일은 외곽의 VDD 파워 링에 연결되고,
GND 레일은 그라운드 파워 링에 연결된다.
즉, 이러한 개념을 바탕으로
VDD 레일과 GND 레일 사이의 일정 영역에만 표준 셀을 배치한다.

그림에서 보듯이, 표준 셀에서는 VDD 레일이 위쪽,
GND 레일이 아래쪽에 위치한다.
따라서 인버터를 배치할 때는 PMOS는 위쪽(VDD 근처),
NMOS는 아래쪽(GND 근처)에 배치해야 한다.

하지만 어떤 영역에서는 반대로,
VDD가 아래쪽, GND가 위쪽에 있을 수도 있다.
이 경우 표준 셀의 배치를 상하 반전(flip)시켜
PMOS가 아래쪽, NMOS가 위쪽에 위치하도록 해야 한다.
이러한 상하 반전 배치 기법을 통해,
표준 셀을 다양한 전원 배치 환경에서도 유연하게 배치할 수 있다.

또한 표준 셀이 정수배 폭(integer-multiple width)을 가지는 이유는,
EDA 툴이 배치 자동화(placement automation)를 쉽게 수행할 수 있도록 하기 위함이다.
즉, 배치 가능한 위치(grid)는 이미 정해져 있으며,
EDA 툴은 해당 격자 내에 어떤 셀을 배치할지만 결정한다.

또한 표준 셀 간에 빈 공간(empty space)이 생기지 않도록 해야 한다.
만약 공간이 생기면, 그 폭을 계산하여 필러 셀(filler cell)로 채운다.
이 필러 셀은 논리 기능은 없고, 물리적으로 빈 영역만 채워주는 역할을 한다.

이러한 방식(자동 배치, 필러 삽입 등)을 가능하게 하려면,
표준 셀의 크기는 반드시 정수배 단위(integer multiple)로 정의되어야 하며,
고정된 배치 격자(fixed grid) 위에 정확히 배치되어야 한다.
따라서 표준 셀은 고정된 높이(fixed height)와 정해진 폭 규칙(width rule)을 갖게 된다.

PG 레일(PG Rail)을 포함한 전원 공급 구조(power delivery structure)는 다음과 같은 형태를 가진다.
일반적으로 VDD 전압은 약 1.0V 내외이며,
이 전압은 먼저 파워 링(power ring)으로 공급된 뒤,
PG 레일(Power/Ground Rail)을 통해 칩 내부의 로직 영역(logic area)으로 분배된다.
이때 PG 레일은 반드시 파워 링에 직접 연결될 수도 있지만,
경우에 따라서는 그렇지 않을 수도 있다.

보통 PG 레일이 파워 링과 직접 연결(direct connection)된다고 생각할 수 있지만,
이 경우 전력망 혼잡(power routing congestion)이 심해질 수 있다.
따라서 강의의 후반부에서 보다 효율적인 전원 공급 방식을 따로 다루게 될 것이다.

### Power Strap

이제 가정해보자.
PG 레일이 파워 링과 살짝 접촉(touch)하고,
그 반대쪽 레일은 그라운드 링과 맞닿아 있다고 하자.
이 경우, 중앙에 있는 셀이 전력 패드(power pad)로부터 전류를 공급받으려면,
전류 경로(current path)는 아래 그림과 같이 길게 이어지는 형태를 갖게 된다.

이러한 구조에서는 전류가 흐르는 경로가 길어지므로,
그 결과 전압 강하(voltage drop)가 발생한다.
이 현상을 IR 드롭(IR drop)이라고 부른다.

이는 금속 배선이 이상적인 도체(ideal conductor)가 아니기 때문이다.
모든 금속은 일정한 저항(resistance)을 가지므로,
전류가 흐를 때 항상 일정한 전압 손실(voltage drop)이 발생한다.

따라서 이러한 IR 드롭 현상을 최소화하려면,
추가적인 전원 공급 구조가 필요하며, 이를 파워 스트랩(power strap)이라고 부른다.

그림에서 볼 수 있듯이, PG 레일은 파워 링과 연결되어 있다.
경우에 따라 직접 연결되지 않을 수도 있지만,
이 예시에서는 PG 레일이 파워 링과 직접 연결된 구조로 설명한다.

하지만 이 방식만으로는 충분하지 않다.
왜냐하면 전류가 한 방향(one-direction)으로만 흐르기 때문이다.
따라서 파워 링과 PG 레일 사이에 수직 스트랩(vertical strap)을 추가하면,
전류가 흐르는 경로를 짧고 효율적으로 줄일 수 있다.

즉, 기존의 길게 우회하는 전류 경로(rounding path) 대신,
여러 개의 굵은 수직 스트랩(thick vertical strap)을 배치하면
전류 경로를 짧게 만들고, 그 결과 IR 드롭을 효과적으로 줄일 수 있다.

또한 수평 스트랩(horizontal strap)을 함께 사용하면
세로 방향 전압 강하도 줄일 수 있다.
보통 저층 금속(M1, M2)은 저항이 높고,
고층 금속(M7, M8)은 저항이 낮다.
따라서 상위 금속층(high-level metal)을 이용해
더 많은 파워 스트랩을 연결하면,
PG 레일에서 발생하는 IR 드롭을 훨씬 더 효과적으로 줄일 수 있다.

## 전력 공급 요약

좋다. 지금까지가 패드에서 내부 로직까지의 전력 공급 경로(power delivery path)에 대한 요약이다.

전력 공급 구조(power delivery network, PDN)를 설계할 때는 다음 순서를 따라야 한다.
먼저 전원 패드(power pad)에서 시작하여,
이 패드를 파워 링(power ring)에 연결한다.
그다음 두껍고 저항이 낮은 고층 금속층(high-level metal)을 이용해
파워 스트랩(power strap)을 형성한다.
표준 셀은 PG 레일(PG rail) 위에 배치되며,
이 PG 레일은 파워 링 또는 파워 스트랩과 전기적으로 연결된다.

경우에 따라 PG 레일이 파워 링과 직접 연결되지 않아도 괜찮다.
왜냐하면 여러 개의 파워 스트랩이 존재하면,
이 스트랩들만으로도 충분히 전류를 분배할 수 있기 때문이다.
즉, 파워 스트랩이 많을수록 PG 레일을 파워 링에 직접 연결할 필요가 줄어든다.

PG 레일이 구성된 후에는,
그 위의 지정된 영역(fixed placement region) 안에 표준 셀을 배치한다.
이렇게 고정된 배치 영역을 사용하는 이유는
EDA 툴이 셀 배치를 자동으로 처리하기 쉽게 만들기 위함이다.

## PnR 요약

좋다. 이제 배치(place)와 배선(route) 과정에 대해 다시 정리하자.
앞서 언급했듯이, 이 과정은 EDA 툴에 의해 자동으로 수행된다.
즉, 먼저 표준 셀을 배치하고,
그다음 금속 배선을 이용해 셀 간의 연결(routing)을 수행한다.

그림에서 볼 수 있듯이,
표준 셀은 PG 레일을 통해 전원을 공급받으며,
이 PG 레일은 고층 금속층(high-level metal)에 의해 파워 스트랩(strap)으로 연결된다.
이 스트랩은 다시 파워 링(power ring)과 이어져 전체 전력망을 형성한다.
배치가 완료된 후, EDA 툴은 라우팅 과정을 통해
이 모든 연결 정보를 자동으로 생성하고 정의한다.

좋다. 다음은 칩의 전원 배치 예시이다.
그림에서 보면 여러 개의 패드(pad)가 보인다.
그중 일부는 전원 패드(power pad)이고,
일부는 신호 패드(signal pad)이다.
전원 패드는 출력이 금속 링(metal ring)에 직접 연결되어 있으며,
신호 패드는 내부 로직 회로(internal logic)에 연결되어 서로 통신한다.

즉, 그림처럼 파워 링(power ring) 또는 파워 스트랩(power strap)을 구성하면,
각 표준 셀이 이 구조에 연결되어 전압(VDD)을 안정적으로 공급받게 된다.

## ASIC design procedure

좋다. 이제 ASIC 설계 절차(ASIC design procedure)를 간단히 살펴보자.

ASIC을 상위 수준(high-level)에서 설계할 때는
먼저 응용 분야(application)와 알고리즘(algorithm)을 결정해야 한다.
그다음 사용할 프로그래밍 언어(language)와 운영체제(OS)를 정해야 하며,
이 선택에 따라 컴파일러(compiler)와 명령어 집합 구조(ISA, Instruction Set Architecture)가
시스템 전체 계층(system stack)을 구성하게 된다.

예를 들어 AI 애플리케이션을 구현한다고 가정하면,
이를 구동할 하드웨어 플랫폼(hardware platform)과
그 플랫폼이 이해할 수 있는 명령어 집합(ISA)이 필요하다.
AI 애플리케이션은 보통 Python으로 작성되지만,
결국 이 코드는 하드웨어가 해석할 수 있는 명령어 수준으로 변환되어야 한다.

이러한 Python이나 C++으로 작성된 프로그램은
운영체제(Windows, Ubuntu, iOS 등) 위에서 실행된다.
그리고 각 운영체제의 컴파일러(compiler)는
이 고수준 언어를 명령어 집합(instruction set)의 조합으로 변환한다.

변환된 명령어 집합(instruction set)은
결국 하드웨어(ASIC)로 전달된다.
각 명령어는 덧셈(add), 로드(load), 스토어(store) 등
하나의 단일 연산(single operation)을 수행하는 역할을 한다.

즉, 컴파일러의 역할은
여러 개의 명령어를 최적화된 조합(optimized instruction group)으로 묶어
이를 타깃 하드웨어(ASIC)로 전달하는 것이다.

하드웨어의 저수준 구조(low-level architecture)를 보면,
ASIC 내부에는 마이크로아키텍처(micro-architecture)와 명령어 집합(ISA)이 존재한다.
하드웨어는 컴파일러로부터 명령어를 받아
이를 디코딩(decode)하여 내부의 IP 블록(IP block)들을 동작시킨다.

이러한 IP 블록 각각은
RTL(Register Transfer Level) 언어로 작성되어 있다.
즉, Verilog나 SystemVerilog 같은 하드웨어 기술 언어(HDL)로 구현된 것이다.
이 RTL 코드는 합성(synthesis)을 거쳐 게이트 레벨 넷리스트(gate-level netlist)로 변환되고,
이후 배치 및 배선(place & route) 과정을 통해
물리적 레이아웃(physical layout)으로 구현된다.

과거의 디지털 회로 설계는 대부분 수동 회로 설계(manual design)에 의존했다.
하지만 오늘날에는 칩 구현 과정의 상당 부분이
EDA 자동화 도구(software automation tool)로 대체되었다.

예전에는 설계자들이 직접 회로를 구성하거나
브레드보드(breadboard)를 이용해 동작을 검증해야 했다.
그러나 하드웨어 기술 언어(HDL)가 등장하면서
이제는 설계한 HDL 코드가 게이트 레벨 넷리스트로 자동 변환되어
수동 검증이 거의 필요하지 않게 되었다.
즉, 표준 셀을 HDL로 기술하고,
그 코드를 시뮬레이션(simulation)하는 것만으로도
모듈의 정의(module definition)와 디지털 회로의 기능(functionality)을 충분히 검증할 수 있다.

따라서 현재의 고수준 검증(high-level verification) 단계에서는
디자이너가 HDL 프로그램을 작성하고,
그 동작을 시뮬레이션하여 기능적 동작(functional behavior)을 확인하면 된다.
최근에는 하드웨어 기술 언어(HDL)뿐 아니라
시스템 수준 설계(System-level design)에서도 HDL을 활용하는 경우가 많다.
예를 들어, 프로세싱 유닛의 개수나 연산 구조를 탐색할 때,
Verilog와 같은 HDL뿐만 아니라
SystemC나 Python 기반의 아키텍처 시뮬레이터를 함께 사용해
고수준의 설계 탐색(design exploration)을 수행한다.
또한 일부 하드웨어의 동작은
Verilog 시뮬레이션 대신
SystemC 또는 Python 기반 아키텍처 시뮬레이터로
더 높은 수준에서 시뮬레이션할 수 있다.

이러한 시뮬레이션은 아키텍처 시뮬레이터(architecture simulator)에서 수행된다.
일반적으로 디지털 회로 엔지니어(digital circuit engineer)는
이러한 환경에서 Verilog 프로그램으로 IP 블록을 설계하고 검증하는 일을 담당한다.

최근에는 이 모든 설계 과정을 완전 자동화(fully automated)하려는 시도가 많지만,
현실적으로는 디지털 설계 자동화(EDA)가
다른 분야의 자동화보다 훨씬 복잡하고 어렵다는 점이 확인되고 있다.

## HDL?

앞서 여러 번 언급한 하드웨어 기술 언어(HDL, Hardware Description Language)란 무엇일까?
이는 하드웨어의 구조(structure)와 동작(behavior)을 기술하기 위해 만들어진
특수한 형태의 프로그래밍 언어이다.
HDL은 회로의 구조와 동작을 모두 기술할 수 있으며,
특히 ASIC(Application-Specific Integrated Circuit) 설계를 위해 사용된다.

즉, 디지털 회로 기반 설계(digital circuit design)를 자동화하고자 할 때,
HDL은 주로 CPU, GPU 등 범용 하드웨어(general-purpose hardware) 설계에 많이 활용된다.
하지만 ASIC은 각 반도체가 수행하는 기능과 사양(specification)이 모두 다르기 때문에,
자동화가 쉽지 않다.
이 때문에 ASIC 설계에서는 수작업 기반의 설계와 최적화 작업이 여전히 필수적이다.

따라서 이러한 경우, Verilog나 SystemVerilog 같은
하드웨어 기술 언어가 디지털 기반 ASIC 설계에 매우 유용하게 사용된다.

HDL을 사용하는 가장 큰 장점 중 하나는 시뮬레이션 속도이다.
예를 들어, 아날로그 회로처럼 직접 회로도나 레이아웃을 그리는 방식과 비교하면,
HDL로 작성된 디지털 회로는 단순히 논리 연산(logic operation)과 기능적 조건(functionality)만 검증하면 되므로
시뮬레이션 속도가 훨씬 빠르다.

즉, HDL 기반 디지털 회로 시뮬레이션은
SPICE 기반 아날로그 시뮬레이션보다 훨씬 빠르다.

이제 ASIC 설계 흐름(ASIC design flow)을 요약해보자.
디지털 회로 기반 ASIC을 설계하려면,
먼저 Verilog 코드 작성(HDL programming)을 하고,
그 다음 합성(synthesis)을 수행해야 한다.

이 과정을 프런트엔드(Front-End of Line)라 부른다.
즉, Verilog 프로그램을 게이트 레벨 구조로 변환한 뒤,
이제 백엔드(Back-End of Line) 단계로 넘어가
매크로 배치(floorplanning), 표준 셀 배치(placement),
그리고 배선(routing)을 수행하여 실제 물리적 구현(physical implementation)을 완성한다.

즉, ASIC 설계의 전체 흐름은 다음과 같다.

1. Verilog 프로그램 작성 (HDL 코딩)
2. 합성 (Synthesis)
3. 배치 (Placement)
4. 배선 (Routing)
   즉, Verilog 코드로부터 시작해 최종 레이아웃(Layout)에 이르는 전체 과정이
   ASIC 설계의 기본적인 디자인 플로우(design flow)이다.