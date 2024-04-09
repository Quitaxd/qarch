#!/usr/bin/env bash

PKGLIST="yay-bin paru-bin ventoy-bin nvm vesktop-bin"
reponame="qarch"
repodir="$HOME/qarch/x86_64"
customdir="$HOME/qarch/custom"

rm $repodir/*

for pkg in $PKGLIST;
do
	olddir="$PWD"
	if [ -d "/tmp/$pkg" ]; then
		rm -rf /tmp/$pkg
	fi
	git clone https://aur.archlinux.org/$pkg.git /tmp/$pkg
	cd /tmp/$pkg
	makepkg -s
	cp $pkg*.pkg.tar.zst $repodir

done

cd $repodir
cp $customdir/* $repodir
repo-add $reponame.db.tar.gz *.pkg.tar.zst
rm $reponame.{db,files}
mv $reponame.db.tar.gz $reponame.db
mv $reponame.files.tar.gz $reponame.files
cd $repodir/..
git add .
git commit -m "Update $reponame Repo!"
git push
cd $olddir
