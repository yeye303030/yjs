# ---- 构建阶段（如需编译可放开） ----
FROM python:3.11-slim AS builder

WORKDIR /app
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

# ---- 运行阶段 ----
FROM python:3.11-slim

# 非 root 用户，提高安全性
RUN useradd -m -u 1000 appuser
USER appuser

WORKDIR /app
# 把依赖从 builder 阶段拷过来
COPY --from=builder /root/.local /home/appuser/.local
ENV PATH=/home/appuser/.local/bin:$PATH

COPY app.py .
EXPOSE 5000

CMD ["python", "app.py"]
