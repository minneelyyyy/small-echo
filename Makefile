
all:
	nasm -f bin echo.asm -o ./echo
	chmod +x ./echo

clean:
	rm ./echo
