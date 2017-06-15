FROM python:alpine
ENV http_proxy http://proxy.aset.psu.edu:8080
ENV https_proxy http://proxy.aset.psu.edu:808
ENV PIP_OPTIONS="--proxy $http_proxy"
RUN ["apk", "update"]
RUN ["apk", "upgrade"]
COPY . /
RUN pip install -r requirements.txt
ENV http_proxy ""
ENV https_proxy ""
CMD ["gunicorn","-b","0.0.0.0:8080","app:app"]


