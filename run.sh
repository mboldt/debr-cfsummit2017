export PKGNAME="nginx-light"

export PKGLIST="$PKGNAME `apt-cache depends $PKGNAME | awk '/Depends:/{print$2}'`"

rm -rf *.deb
apt-get download $PKGLIST
rm -rf ./apt/
mkdir ./apt
for p in `ls *.deb`; do
	dpkg-deb -x $p ./apt/
done
ls ./apt/
