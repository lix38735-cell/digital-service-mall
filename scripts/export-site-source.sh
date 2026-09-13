#!/usr/bin/env bash
set -Eeuo pipefail

site_dir="${1:-}"
output_file="${2:-/root/site-source-$(date +%Y%m%d-%H%M%S).tar.gz}"

if [[ -z "$site_dir" ]]; then
  echo "用法: bash export-site-source.sh /网站源码目录 [输出文件]"
  echo "示例: bash export-site-source.sh /var/www/app"
  exit 1
fi

if [[ ! -d "$site_dir" ]]; then
  echo "目录不存在: $site_dir"
  exit 1
fi

site_dir="$(cd "$site_dir" && pwd)"

case "$output_file" in
  "$site_dir"|"$site_dir"/*)
    echo "输出文件不能放在源码目录内"
    exit 1
    ;;
esac

tar   --exclude='.git'   --exclude='.env'   --exclude='.env.*'   --exclude='*.pem'   --exclude='*.key'   --exclude='*.sqlite'   --exclude='*.sqlite3'   --exclude='node_modules'   --exclude='vendor'   --exclude='.next'   --exclude='.nuxt'   --exclude='dist'   --exclude='build'   --exclude='coverage'   --exclude='storage/logs'   --exclude='storage/framework/cache'   --exclude='storage/framework/sessions'   --exclude='storage/framework/views'   --exclude='public/uploads'   --exclude='uploads'   --exclude='tmp'   --exclude='*.log'   -C "$site_dir"   -czf "$output_file"   .

chmod 600 "$output_file"

echo "源码已安全导出：$output_file"
echo "已排除环境变量、密钥、数据库、日志、上传文件、构建产物和依赖目录。"
