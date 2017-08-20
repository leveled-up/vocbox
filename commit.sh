git add .
git commit -m "$1"
git push
DATE=`date +%s`
zip -r .zip/vocbox-backup-$DATE.zip functions/* public/* .travis.yml README.md
