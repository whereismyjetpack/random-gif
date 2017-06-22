FROM python:alpine
ENV http_proxy "http://proxy.aset.psu.edu:8080"
ENV https_proxy "http://proxy.aset.psu.edu:8080"
ENV PIP_OPTIONS="--proxy http://proxy.aset.psu.edu:8080"
RUN ["apk", "update"]
RUN ["apk", "upgrade"]
COPY . /
RUN pip install -U pip 
RUN pip install -r requirements.txt
CMD ["gunicorn","-b","0.0.0.0:8080","app:app"]


