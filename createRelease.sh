tar cvfz apt-blob.tar.gz apt
rm -rf apt-release 2>/dev/null
mkdir apt-release && cd apt-release
bosh init-release
cat > config/final.yml << EOF
---
name: apt
blobstore:
  provider: local
  options:
    blobstore_path: /tmp/apt-blobstore
EOF
echo "Modified config/final.yml"
bosh generate-package apt-package
echo "Added package apt-package"
bosh add-blob ../apt-blob.tar.gz apt-blob/apt-blob.tar.gz
bosh -n upload-blobs
echo "Added blobs apt-blob"
cat > packages/apt-package/spec << EOF
---
name: apt-package
dependencies: []
files:
- apt-blob/apt-blob.tar.gz

EOF
echo "Updated package spec "

cat > packages/apt-package/packaging << 'EOF'
cp $BOSH_COMPILE_TARGET/apt-blob/apt-blob.tar.gz $BOSH_INSTALL_TARGET/
cd $BOSH_INSTALL_TARGET
tar zxvf *.tar.gz
rm *.tar.gz
EOF

bosh generate-job nginx-light


echo "Updated package packaging "
bosh create-release --version 0.1 --tarball=../apt-release.v0.1.tgz --force

