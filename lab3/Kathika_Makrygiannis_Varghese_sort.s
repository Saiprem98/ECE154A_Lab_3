##############################################################################
# File: sort.s
# Skeleton for ECE 154A
##############################################################################

	.data
student:
	.asciiz "Sai Kathika, Pete Makrygiannis, Rahul Varghese:\n" 	# Place your name in the quotations in place of Student
	.globl	student
nl:	.asciiz "\n"
	.globl nl
sort_print:
	.asciiz "[Info] Sorted values\n"
	.globl sort_print
initial_print:
	.asciiz "[Info] Initial values\n"
	.globl initial_print
read_msg: 
	.asciiz "[Info] Reading input data\n"
	.globl read_msg
code_start_msg:
	.asciiz "[Info] Entering your section of code\n"
	.globl code_start_msg

key:	.word 268632064			# Provide the base address of array where input key is stored(Assuming 0x10030000 as base address)
output:	.word 268632144			# Provide the base address of array where sorted output will be stored (Assuming 0x10030050 as base address)
numkeys:	.word 6				# Provide the number of inputs
maxnumber:	.word 10			# Provide the maximum key value


## Specify your input data-set in any order you like. I'll change the data set to verify
data1:	.word 1
data2:	.word 2
data3:	.word 3
data4:	.word 5
data5:	.word 6
data6:	.word 8
# data1:	.word 1
# data2:	.word 4
# data3:	.word 1
# data4:	.word 2
# data5:	.word 7
# data6:	.word 2
	.text

	.globl main
main:					# main has to be a global label
	addi	$sp, $sp, -4		# Move the stack pointer
	sw 	$ra, 0($sp)		# save the return address
			
	li	$v0, 4			# print_str (system call 4)
	la	$a0, student		# takes the address of string as an argument 
	syscall	

	jal process_arguments
	jal read_data			# Read the input data

	j	ready

process_arguments:
	
	la	$t0, key
	lw	$a0, 0($t0)
	la	$t0, output
	lw	$a1, 0($t0)
	la	$t0, numkeys
	lw	$a2, 0($t0)
	la	$t0, maxnumber
	lw	$a3, 0($t0)
	jr	$ra	

### This instructions will make sure you read the data correctly
read_data:
	move $t1, $a0
	li $v0, 4
	la $a0, read_msg
	syscall
	move $a0, $t1

	la $t0, data1
	lw $t4, 0($t0)
	sw $t4, 0($a0)
	la $t0, data2
	lw $t4, 0($t0)
	sw $t4, 4($a0)
	la $t0, data3
	lw $t4, 0($t0)
	sw $t4, 8($a0)
	la $t0, data4
	lw $t4, 0($t0)
	sw $t4, 12($a0)
	la $t0, data5
	lw $t4, 0($t0)
	sw $t4, 16($a0)
	la $t0, data6
	lw $t4, 0($t0)
	sw $t4, 20($a0)

	jr	$ra


counting_sort:
######################### 
## your code goes here ##


# count 268632000 -> 268632040
#########################
# key = $a0 
# output = $a1
# numkeys = $a2
# maxnumber = $a3

# key 268632064 -> 268632084
# out 268632144 -> 268632164

# count 268632000 -> 268632040
# 0x10030000 as base address)
# output will be stored (Assuming 0x10030050 as base address)

lui $t2, 4096
ori $t2, $t2, 28672

add $t0, $zero, $zero
firstLoop:
    slt $t8, $a3, $t0	#n ≤ maxnumber :for loop check 
    bne $t8, $zero, doneloop1	# exit if check broken 
    sll $t1,$t0,2		# jump by 4 next spot in array
    add $t1,$t1,$t2		# t1 holds next spot in array 
    sw $zero,0($t1)		# count[n] = 0;
    addi $t0, $t0, 1	#  n++:
    j firstLoop
doneloop1:

add $t0, $zero, $zero
secLoop:
    slt $t8, $t0, $a2	#n ≤ maxnumber :for loop check 
    beq $t8, $zero, doneloop2	# exit if check broken 
    sll $t1, $t0, 2		# jump by 4 next spot in array
    add $t1, $t1, $a0	# t1 holds next spot in array 
    lw $t3, 0($t1)		#store keys[n] in t3
    sll $t1, $t3, 2		#t1 has address w/o base address 
    add $t1, $t1, $t2	# add base address to t1 
    lw $t3, 0($t1)		# t3 =  count[keys[n]]
    addi $t3, $t3, 1	# t3 = count[keys[n]]++;
    sw $t3, 0($t1);		# store count[keys[n]]
    addi $t0, $t0, 1	#  n++:
    j secLoop
doneloop2:

addi $t0, $zero, 1
thirdLoop:
    slt $t8, $a3, $t0	#n ≤ maxnumber :for loop check 
    bne $t8, $zero, doneloop3	# exit if check broken 
    sll $t1,$t0,2		# jump by 4 next spot in array
    add $t1,$t1,$t2		# t1 holds next spot in array  
    lw $t4,0($t1)		# t4 = count[n]
    lw $t5,-4($t1)		# t5 = count[n-1]
    add $t6,$t4,$t5		# t6 = count[n] + count[n-1];
    sw,$t6,0($t1)		# put count[n] + count[n-1] in  count[n]
    addi $t0, $t0, 1	#  n++:
    j thirdLoop
doneloop3:

add $t0, $zero, $zero
lastLoop:
    slt $t8, $t0, $a2	#n ≤ numkeys :for loop check 
    beq $t8, $zero, final	# exit if check broken 
    sll $t1, $t0, 2		# jump by 4 next spot in array
    add $t1, $t1, $a0	# t1 holds next spot in array
    lw $t3, 0($t1)		 # t3 = keys[n]
    add $t5, $t3, $zero	
    sll $t3, $t3, 2		# t3 address keys[n]
    add $t1, $t3, $t2	# t2 = base address t1 = t3 + t2  has output address 
    add $t7, $t1, $zero
    lw $t3, 0($t1)		# t3 =  count[keys[n]]
    add $t6, $t3, $zero
    addi $t3, $t3, -1	# t3 =  count[keys[n]] -1
    sll $t1, $t3, 2		# next memory address 
    add $t1, $t1, $a1	# add base address
    sw $t5, 0($t1)		# save keys[n]
    addi $t6, $t6, -1	#count[keys[n]]--
    sw $t6, 0($t7)


    addi $t0, $t0, 1
    j lastLoop
final:

# int keys[numkeys];
# int output[numkeys];
# 	countingsort(int *keys, int *output, numkeys, maxnumber) {
# 		int count[maxnumber+1], n;
# 		for (n = 0; n++; n ≤ maxnumber)
# 			count[n] = 0;
# 		for (n = 0; n++; n < numkeys)
# 			count[keys[n]]++;
# 		for (n = 1; n++; n ≤ maxnumber)
# 		 	count[n] = count[n] + count[n-1];
# 		for (n = 0; n++; n < numkeys) {
# 		 	output[count[keys[n]]-1] = keys[n];
# 		 	count[keys[n]]--;
# 	}
# }

# lw $t0, 268632000 #beginning of count array 

# add $t2, $zero, $a3 
# li $t1, 4

# mult $t1, $t2
# mflo $t3 
# add $t4, $t0, $t3 #end of count array 268632040

# lw $t0, 20($a0)
# sw $t0, 0($a1)
# addi $a0, $a0, 4
# sw $a0, 4($a1)

# addi $t5, $zero, $a2
# loop2:
# 	beq $t5, $zero, loop3
# 	lw $t0, 0($a0)
# 	addi $t5, $t5, -1
# 	j loop2
	

#########################
 	jr $ra
#########################


##################################
#Dont modify code below this line
##################################
ready:
	jal	initial_values		# print operands to the console
	
	move 	$t2, $a0
	li 	$v0, 4
	la 	$a0, code_start_msg
	syscall
	move 	$a0, $t2

	jal	counting_sort		# call counting sort algorithm

	jal	sorted_list_print


				# Usual stuff at the end of the main
	lw	$ra, 0($sp)		# restore the return address
	addi	$sp, $sp, 4
	jr	$ra			# return to the main program

print_results:
	add $t0, $zero, $a2 # No of elements in the list
	add $t1, $zero, $a0 # Base address of the array
	move $t2, $a0    # Save a0, which contains base address of the array

loop:	
	beq $t0, $zero, end_print
	addi, $t0, $t0, -1
	lw $t3, 0($t1)
	
	li $v0, 1
	move $a0, $t3
	syscall

	li $v0, 4
	la $a0, nl
	syscall

	addi $t1, $t1, 4
	j loop
end_print:
	move $a0, $t2 
	jr $ra	

initial_values: 
	move $t2, $a0
        addi	$sp, $sp, -4		# Move the stack pointer
	sw 	$ra, 0($sp)		# save the return address

	li $v0,4
	la $a0,initial_print
	syscall
	
	move $a0, $t2
	jal print_results
 	
	lw	$ra, 0($sp)		# restore the return address
	addi	$sp, $sp, 4

	jr $ra

sorted_list_print:
	move $t2, $a0
	addi	$sp, $sp, -4		# Move the stack pointer
	sw 	$ra, 0($sp)		# save the return address

	li $v0,4
	la $a0,sort_print
	syscall
	
	move $a0, $t2
	
	#swap a0,a1
	move $t2, $a0
	move $a0, $a1
	move $a1, $t2
	
	jal print_results
	
    #swap back a1,a0
	move $t2, $a0
	move $a0, $a1
	move $a1, $t2
	
	lw	$ra, 0($sp)		# restore the return address
	addi	$sp, $sp, 4	
	jr $ra