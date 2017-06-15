FROM python:alpine
RUN ["apk", "update"]
RUN ["apk", "upgrade"]
COPY . /
RUN pip install -r requirements.txt
CMD ["gunicorn","-b","0.0.0.0:8080","app:app"]


