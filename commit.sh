git add .
git commit -m "$1"
git push
DATE=`date +%s`
zip .zip/vocbox-backup-$DATE.zip functions/* public/* .travis.yml README.md
coffee -cbo .out/ public/
cp public/* .out/
rm .out/*.coffee
