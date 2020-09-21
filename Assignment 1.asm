            .data
upper_word:     .asciiz
            "Alpha\n","Bravo\n","China\n","Delta\n","Echo\n","Foxtrot\n",
            "Golf\n","Hotel\n","India\n","Juliet\n","Kilo\n","Lima\n",
            "Mary\n","November\n","Oscar\n","Paper\n","Quebec\n","Research\n",
            "Sierra\n","Tango\n","Uniform\n","Victor\n","Whisky\n","X-ray\n",
            "Yankee\n","Zulu\n"
upper_word_offset:  .word
            0,7,14,21,28,34,43,49,56,63,71,
            77,83,89,99,106,113,121,131,
            139,146,155,163,171,178,186
lower_word:     .asciiz
            "alpha\n","bravo\n","china\n","delta\n","echo\n","foxtrot\n",
            "golf\n","hotel\n","india\n","juliet\n","kilo\n","lima\n",
            "mary\n","november\n","oscar\n","paper\n","quebec\n","research\n",
            "sierra\n","tango\n","uniform\n","victor\n","whisky\n","x-ray\n",
            "yankee\n","zulu\n"
lower_word_offset:  .word
            0,7,14,21,28,34,43,49,56,63,71,
            77,83,89,99,106,113,121,131,
            139,146,155,163,171,178,186
number_str: .asciiz
            "zero\n", "First\n", "Second\n", "Third\n", "Fourth\n",
            "Fifth\n", "Sixth\n", "Seventh\n","Eighth\n","Ninth\n"
num_offset: .word
            0,6,13,21,28,36,43,50,59,67

            .text
            .globl main
main:       li $v0, 12 # read character
            syscall
            add $t5, $0, $v0
            addi $a0, $0, 0xA 
            li $v0, 11
            syscall
            add $v0, $0, $t5
            beq $v0, 63, exit  # the ascii code for '?' is 63. If the input char ascii code is 63 then the input char is '?' and we want to exit.
            blt $v0, 48, stars # The ascii code range for letter + digits is 48 - 122
            bgt $v0, 122, stars
            
           # test is upper case?
            slti $t1, $v0, 91 # Character ascii < 91? 
            sub $t2, $v0, 64
            slt $t2, $0, $t2 # Character ascii > 64 ?
            and $s0, $t1, $t2 # Character ascii in (64, 91)
            beq $s0, 1, getUpperWord

	   # test is lower case?
	   slti $t1, $v0, 123
	   sub $t2, $v0, 96
	   slt $t2, $0, $t2
	   and $s1, $t1, $t2
	   beq $s1,1,getLowerWord

            # test is number?
            slti $t3, $v0, 58
            sub $t4, $v0, 48
            sle $t4, $0,$t4 
            and $s2, $t3, $t4
            beq $s2, 1, getNumber
            j stars
	    

getNumber:  sub $t2, $v0, 48
            mul $t2, $t2, 4
            la $s0, num_offset
            add $s0, $s0, $t2
            lw $s1, ($s0)
            la $a0, number_str
            add $a0, $a0, $s1
            li $v0, 4
            syscall
            j main

   
getUpperWord: sub $t3, $v0, 65
            mul $t3, $t3, 4
            la $s0, upper_word_offset
            add $s0, $s0, $t3
            lw $s1, ($s0)
            la $a0, upper_word
            add $a0, $s1, $a0
            li $v0, 4
            syscall
            j main

            # lower case word
getLowerWord: sub $t4, $v0, 97
            mul $t4, $t4, 4
            la $s0, lower_word_offset
            add $s0, $s0, $t4
            lw $s1, ($s0)
            la $a0, lower_word
            add $a0, $s1, $a0
            li $v0, 4
            syscall
            j main

stars:      add $a0, $0, 42 # '*'
            li $v0, 11 # print character
            syscall
            j main

exit:       li $v0, 10 # exit
            syscall
