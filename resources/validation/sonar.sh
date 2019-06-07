echo "Downloading sonar"

if [[ -n $SONAR_TOKEN &&  -n $SONAR_ORGANIZATION ]];
then
  if [[ ! -e bin/sonar ]];
  then
    curl -q https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-3.3.0.1492-linux.zip > bin/sonar.zip
    unzip -q bin/sonar.zip -d bin/
    mv bin/sonar-scanner* bin/sonar
  fi

  echo "Running validation"
  bash resources/validation/validate.sh


  SLUG=`echo $REPOSITORY_URL | sed 's/git@github.com://' | sed 's/https:\/\/.*github.com\///'`
  USER=`echo $SLUG | cut -d '/' -f 1`
  REPO=`echo $SLUG | cut -d '/' -f 2`

  echo "Running sonar"
  bin/sonar/bin/sonar-scanner \
      -Dproject.settings=resources/validation/sonar.properties \
      -Dsonar.projectKey=$USER-$REPO \
      -Dsonar.organization=$SONAR_ORGANIZATION \
      -Dsonar.login=$SONAR_TOKEN
fi
