#!/bin/bash


read -p " PC name: " hostname
read -p " username: " username
echo  $hostname > /etc/hostname
passwd_



(
echo n;
echo p;
echo 1;
echo 2048;
echo -e "\n";
echo w;
echo q
) | fdisk /dev/sda

fdisk -l

mkfs.ext4 /dev/sda1

mount /dev/sda1 /mnt

pacstrap /mnt base linux linux-firmware base-devel

genfstab -U /mnt  >> /mnt/etc/fstab 

arch-chroot /mnt /bin/bash -c "ln -sf /usr/share/zoneinfo/Europe/Tallinn /etc/localtime"
arch-chroot /mnt /bin/bash -c "hwclock --systohc"
arch-chroot /mnt /bin/bash -c "echo $hostname > /etc/hostname "
arch-chroot /mnt /bin/bash -c "yes | pacman -S vim nano "
arch-chroot /mnt /bin/bash -c "yes | pacman -S networkmanager "
arch-chroot /mnt /bin/bash -c "yes | systemctl enable NetworkManager "
arch-chroot /mnt /bin/bash -c "yes | pacman -S grub "
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo 'LANG="us_US.UTF-8"' > /etc/locale.conf
arch-chroot /mnt /bin/bash -c "locale-gen"
arch-chroot /mnt /bin/bash -c "mkinitcpio -P"
echo "root:passwd_" | arch-chroot /mnt chpasswd 
arch-chroot /mnt /bin/bash -c "grub-install /dev/sda "
arch-chroot /mnt /bin/bash -c "grub-mkconfig -o /boot/grub/grub.cfg "
arch-chroot /mnt /bin/bash -c "useradd -m -g users -G wheel -s /bin/bash $username "
arch-chroot /mnt /bin/bash -c "passwd $username"



# -*- ENCODING: UTF-8 -*-

arch-chroot /mnt /bin/bash -c "pacman -Syu"
arch-chroot /mnt /bin/bash -c "pacman -S xorg-server xorg-drivers xorg-xinit"
 
#yaourt -Syua
echo
MENU="
....................           
   
   * Arch linux *  
....................
* 1    GNOME
* 2    XFCE

  q    Exit
"

while true; do
  clear
  echo "$MENU"
  echo -n " GUI "
  read INPUT # Read user input and assign it to variable INPUT
 # Please make your choice
  case $INPUT in
  
    1)
    echo 
    echo  " GNOME "
    echo 
    echo press ENTER 
    echo
arch-chroot /mnt /bin/bash -c "pacman -S gnome gnome-extra gnome-tweaks"
arch-chroot /mnt /bin/bash -c "systemctl enable gdm.service"
arch-chroot /mnt /bin/bash -c "systemctl enable NetworkManager.service"    
    reboot

 
    #read
    ;;
    2)
    echo
    echo    " XFCE "
    echo
    echo press ENTER
    echo
arch-chroot /mnt /bin/bash -c "pacman -S deepin deepin-extra sddm sddm-kcm"
arch-chroot /mnt /bin/bash -c "systemctl enable sddm.service"
arch-chroot /mnt /bin/bash -c "systemctl enable NetworkManager.service"
    reboot
 
    ;;
  
 
 esac

done
