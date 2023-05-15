nasm $1.asm -o $1.com 2> error.txt 
if test -s error.txt; then
	echo "compile error!"
	cat error.txt
else
	sudo mount -o loop ../pmtest.img /mnt/floppy
	sudo cp $1.com /mnt/floppy/
	sudo umount /mnt/floppy
	cd ../
	bochs
fi
