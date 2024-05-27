Include "scripts/prompt.sh"

Describe "prompt_choice()"
	It "choices first with 'y'"
		Data "y"
		When call prompt_choice "prompt" "first" "second"
		The line 1 of stderr should equal "1) first"
		The line 2 of stderr should equal "2) second"
		The line 3 of stderr should equal "prompt: "
		The stdout should equal "first"
	End

	It "choices second"
		Data "2"
		When call prompt_choice "prompt" "first" "second" "third"
		The line 1 of stderr should equal "1) first"
		The line 2 of stderr should equal "2) second"
		The line 3 of stderr should equal "3) third"
		The line 4 of stderr should equal "prompt: "
		The stdout should equal "second"
	End

	It "choices wrong choice first"
		Data
			#|3
			#|2
		End
		When call prompt_choice "prompt" "first" "second"
		The line 1 of stderr should equal "1) first"
		The line 2 of stderr should equal "2) second"
		The line 3 of stderr should equal "prompt: Invalid choice"
		The line 4 of stderr should equal "prompt: "
		The line 1 of stdout should equal "second"
	End
End

Describe "prompt_choice_cached()"
	BeforeEach 'temp="$(mktemp)"'

	It "choices first without cache"
		Data "y"
		When call prompt_choice_cached "${temp}" "prompt" "first" "second"
		The line 1 of stderr should equal "1) first"
		The line 2 of stderr should equal "2) second"
		The line 3 of stderr should equal "prompt: "
		The stdout should equal "first"
	End

	It "choices second without cache"
		Data "2"
		When call prompt_choice_cached "${temp}" "prompt" "first" "second"
		The line 1 of stderr should equal "1) first"
		The line 2 of stderr should equal "2) second"
		The line 3 of stderr should equal "prompt: "
		The stdout should equal "second"
	End

	It "choices with wrong cache"
		echo "3" > "${temp}"
		Data "y"
		When call prompt_choice_cached "${temp}" "prompt" "first" "second"
		The line 1 of stderr should equal "1) first"
		The line 2 of stderr should equal "2) second"
		The line 3 of stderr should equal "prompt: "
		The stdout should equal "first"
	End

	It "choices first with cache"
		echo "first" > "${temp}"
		When call prompt_choice_cached "${temp}" "prompt" "first" "second"
		The line 1 of stdout should equal "first"
	End
End

