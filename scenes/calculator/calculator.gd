extends Control

##################################################
var num_label_node: Label	# 숫자를 표시하는 Label 노드 참조

var current_operand: String = "0"	# 현재 입력 중인 숫자
var input_operator: String = ""		# 현재 입력된 연산자
var first_operand: float = 0.0		# 첫 번째 피연산자 값
var memory_value: float = 0.0		# 메모리 저장 값

##################################################
func _ready() -> void:
	num_label_node = $VBoxContainer/MarginContainer2/NumLabel
	# 숫자 출력용 Label 노드를 찾아 변수에 저장
	
	for button in \
		$VBoxContainer/MarginContainer3/GridContainer.get_children():
			button.connect("pressed", Callable(self, "_on_button_pressed").\
				bind(button.name))
	# GridContainer 아래 모든 버튼에 "pressed" 시그널 연결
	# 버튼 이름을 인자로 _on_button_pressed 호출
	
	_update_display()	# 숫자 표시 업데이트

##################################################
func _on_button_pressed(button_value: String) -> void:
# 버튼의 이름을 인자로 받음
	match button_value:
		"Button0", "Button1", "Button2", "Button3", "Button4", "Button5", \
		"Button6", "Button7", "Button8", "Button9":
			_input_digit(button_value[-1])
							# 숫자 버튼이면 마지막 글자(숫자만) 추출해 처리
		"ButtonPoint":		# 소수점 버튼 처리
			_input_point()
		"ButtonAC":			# AC 버튼 처리
			_input_all_clear()
		"ButtonMultiplication", "ButtonDivision", "ButtonPlus", \
		"ButtonMinus":		# 사칙연산자 버튼 처리
			_input_operator(button_value)
		"ButtonEquivalent":	# '=' 버튼 처리
			_input_Equivalent()
		"ButtonMR":			# 메모리 관련 버튼 처리
			_input_memory_recall()
		"ButtonMS":			# 메모리 관련 버튼 처리
			_input_memory_store()
		"ButtonRoot":		# 제곱근 버튼 처리
			_input_root()
		

##################################################
func _input_digit(digit_value: String) -> void:
	if current_operand == "0":
		if digit_value == "0":
			return
				# 현재 값이 0이면, 0을 다시 입력하는 경우 무시하고
		else:	# 0이 아니면 새로 입력한 숫자로 대체
			current_operand = digit_value
	else:		# 0이 아니면 기존 숫자 뒤에 입력된 숫자 추가
		current_operand += digit_value
	
	_update_display()	# 숫자 표시 업데이트

##################################################
func _input_point() -> void:
	if not current_operand.find(".") == -1:
		return					# 현재 숫자에 이미 '.'가 포함되어 있으면 무시
	else:
		current_operand += "."	# '.' 추가
	
	_update_display()	# 숫자 표시 업데이트

##################################################
func _input_all_clear() -> void:	# 모든 입력 상태 초기화
	current_operand = "0"
	input_operator = ""
	first_operand = 0.0
	
	_update_display()			# 숫자 표시 업데이트

##################################################
func _input_operator(operator_value: String) -> void:
	if not input_operator == "":
		_input_Equivalent()
	# 이미 연산자가 입력되어 있으면 먼저 계산 실행
	
	match operator_value:	# 버튼 이름에 따라 실제 연산자 기호 저장
		"ButtonMultiplication":
			input_operator = "*"
		"ButtonDivision":
			input_operator = "/"
		"ButtonPlus":
			input_operator = "+"
		"ButtonMinus":
			input_operator = "-"
	
	first_operand = current_operand.to_float()
	current_operand = "0"
	# 현재 숫자를 첫 번째 피연산자로 저장하고, 입력 초기화

##################################################
func _input_Equivalent() -> void:
	var result: float = 0.0
	
	match input_operator:
		"+":	# 덧셈
			result = first_operand + current_operand.to_float()
		"-":	# 뺄셈
			result = first_operand - current_operand.to_float()
		"*":	# 곱셈
			result = first_operand * current_operand.to_float()
		"/":	# 나눗셈, 0으로 나누기 방지
			if current_operand.to_float() == 0.0:
				return
			
			result = first_operand / current_operand.to_float()
	
	if result == floor(result):
		current_operand = str(int(result))
	else:
		current_operand = str(result)
	# 결과가 정수면 정수형으로, 아니면 실수형 문자열로 변환
	
	input_operator = ""	# 연산자와 첫 피연산자 초기화
	first_operand = 0.0
	
	_update_display()	# 숫자 표시 업데이트

##################################################
func  _input_memory_recall() -> void:
	if memory_value == floor(memory_value):
		current_operand = str(int(memory_value))
	else:
		current_operand = str(memory_value)
	# 메모리 값을 현재 입력값으로 복원
	
	_update_display()	# 숫자 표시 업데이트

##################################################
func _input_memory_store() -> void:
	memory_value = current_operand.to_float()
	# 현재 입력값을 메모리에 저장

##################################################
func _input_root()-> void:
	var value: float = current_operand.to_float()
	if value < 0.0:
		return
	# 음수 제곱근은 처리하지 않음
		
	if sqrt(value) == floor(sqrt(value)):
		current_operand = str(int(sqrt(value)))
	else:
		current_operand = str(sqrt(value))
	# 제곱근 결과가 정수면 정수형으로, 아니면 실수형 문자열로 변환
	
	_update_display()	# 숫자 표시 업데이트

##################################################

func _update_display() -> void:
	num_label_node.text = current_operand
	# 숫자 표시 업데이트
