            .data
buf:              .space 512            
success_msg:      .asciiz "\r\nSuccess! Location: "
fail_msg:         .asciiz "\r\nFail!\r\n"
new_line:         .asciiz "\r\n"
leave_msg:        .asciiz "\r\n Get '?' from input. Exit now"


            .text
            .globl main
main:       la $a0, buf # address of input buffer
            la $a1, 512 # maximum number of characters to read
            li $v0, 8 # read string
            syscall

get_char:   li $v0, 12 # get character
            syscall
            beq $v0, 63, exit
            la $t0, buf
            add $t2, $0, $0

search_string:  lb $t1, 0($t0)
                beq $v0, $t1, success
                addi $t2, $t2, 1
               	bge $t2, $a1, fail
                addi $t0, $t0,1
                j search_string

success:    la $a0, success_msg
            li $v0, 4 # print string
            syscall
            addi $a0, $t2, 1
            li $v0, 1 # print integer
            syscall
            la $a0, new_line
            li $v0, 4
            syscall
            j get_char

fail:       la $a0, fail_msg
            li $v0, 4
            syscall
            j get_char

exit:       
	    la $a0,leave_msg
	    li $v0, 4
	    syscall
	    li $v0, 10
            syscall
