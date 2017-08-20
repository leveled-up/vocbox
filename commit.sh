git add .
git commit -m "$1"
git push
zip -r .zip/vocbox-backup-$DATE.zip functions/* public/* .travis.yml README.md
