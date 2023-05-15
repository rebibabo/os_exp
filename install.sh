#安装nasm
sudo apt-get install nasm
#安装bochs
sudo apt-get install bochs vgabios bochs-x bximage
#从官网下载freedos软盘映像文件
mkdir os
cd os
wget http://bochs.sourceforge.net/guestos/freedos-img.tar.gz
#在当前目录下备份a.img和bochsrc
tar -xvf freedos-img.tar.gz
cp ./freedos-img/a.img ./freedos.img
bximage
# 依次输入1，fd，Enter，pmtest.img
echo -e "megs: 32\nromimage: file=/usr/share/bochs/BIOS-bochs-latest\nvgaromimage: file=/usr/share/bochs/VGABIOS-lgpl-latest\nfloppya: 1_44=freedos.img, status=inserted\nfloppyb: 1_44=pmtest.img, status=inserted\nboot: a\nmouse: enabled=0">bochsrc.txt
bochs -f bochsrc.txt