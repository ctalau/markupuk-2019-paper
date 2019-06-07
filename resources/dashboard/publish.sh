SLUG=`echo $REPOSITORY_URL | sed 's/git@github.com://' | sed 's/https:\/\/.*github.com\///'`
echo "Slug: $SLUG"
USER=`echo $SLUG | cut -d '/' -f 1`
REPO=`echo $SLUG | cut -d '/' -f 2`
CLEAN_REPO_URL="https://github.com/$USER/$REPO"
SOURCE=paper.xml
DELIVERABLE=markupuk.zip

# Publish the PDF
. resources/pdf/publish.sh
. resources/validation/sonar.sh

# Generate the submission bundle
zip -r out/$DELIVERABLE . -x bin/\* resources/\* out/\* .git/\* \*.xpr \
  README.md \
  fork.md \
  .gitignore \
  netlify.toml \
  LICENSE

EDITOR_URL="http://localhost:8080/oxygen-xml-web-author/app/oxygen.html"
EDIT_URL="${EDITOR_URL}?url=gitgh%3A%2F%2Fhttps%253A%252F%252Fgithub.com%252F${USER}%252F${REPO}%2F${BRANCH}%2F${SOURCE}"
echo "window.REPO_LINK = \"${CLEAN_REPO_URL}\";" > out/params.js
echo "window.EDIT_LINK = \"${EDIT_URL}\";" >> out/params.js

if [[ -n $SONAR_TOKEN &&  -n $SONAR_ORGANIZATION ]];
then
  echo "window.SONAR_PROJECT = \"${USER}-${REPO}\";" >> out/params.js
fi
cp resources/dashboard/index.html out/index.html
cp resources/dashboard/site.css out/site.css
cp resources/dashboard/MarkupUK.png out/MarkupUK.png
cp resources/dashboard/MarkupUK@2x.png out/MarkupUK@2x.png
