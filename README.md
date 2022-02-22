**DOCUMENTATION**:

This README is creating a python simple login page, containerize it, pull the image into cluster and provision the cloud infrastructure using Terraform.

Steps executed:

1. Created a login page using python flask. It has username and password fields.
a. The driver code is in the file `app.py`
b. It contains the HTML code for `creating ATC_USERNAME` and `ATC_PASSWORD` Fields. If the username is `ATC` and password is `americantechnologyconsulting` you will be able to login successfully else you will get an access denied error.
c. By default `GET` request is used but when the response is send `POST` will be generated.
d. command to run the flask app if using Windows Powershell:
`set FLASK_APP=app`
`python app.py`
The application will run on port 80.

2. Dockerized the app:
a. Create the Dockefile.
b. create the ecr repository `aws ecr create-repository --repository-name atc-web-app --region us-east-1`
c. authenticate using login password for ecr.
After this password will be generated. Now use this command `aws ecr get-login` and paste the password generated.Retrieve an authentication token and authenticate your Docker client to your registry. `aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 022997318112.dkr.ecr.us-east-1.amazonaws.com`
d. Build the container image and tag it `docker build -t atc-web-app:latest . `
`docker tag atc-web-app:latest 022997318112.dkr.ecr.us-east-1.amazonaws.com/atc-web-app:latest`
The images are MUTUABLE by default but you can change it to IMMUTABLE.
e. Run the docker image `docker run --name atc-web-app:latest -p 80:80 atc-web-app:latest`
f. push the docker image to ecr `docker push 022997318112.dkr.ecr.us-east-1.amazonaws.com/atc-web-app:latest`
