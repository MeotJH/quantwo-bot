# Python 베이스
FROM python:3.9.7

# 작업 디렉토리
WORKDIR /app

# 코드 복사
COPY . .

# 필요한 패키지 설치
RUN pip install --no-cache-dir -r requirements.txt

# 포트 열기 (gunicorn 기본 8080)
EXPOSE 8080

# 서버 실행 (gunicorn으로 wsgi.py 실행)
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "wsgi:app"]
