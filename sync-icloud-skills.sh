#!/bin/bash

# iCloud技能同步脚本
# 功能：从iCloud云盘同步技能到本地

ICLOUD_SKILLS_DIR="$HOME/Library/Mobile Documents/com~apple~CloudDocs/Documents/youdaoclaw-skills"
LOCAL_SKILLS_DIR="$HOME/Library/Application Support/LobsterAI/SKILLs"
TEMP_DIR="/tmp/icloud-skills-sync-$$"

echo "========== iCloud技能同步开始 =========="
echo "时间: $(date '+%Y-%m-%d %H:%M:%S')"

# 创建临时目录
mkdir -p "$TEMP_DIR"

# 同步计数
updated=0
added=0

# 遍历iCloud中的所有zip文件
for zipfile in "$ICLOUD_SKILLS_DIR"/*.zip; do
    if [ -f "$zipfile" ]; then
        skill_name=$(basename "$zipfile" .zip)
        echo ""
        echo "检查技能: $skill_name"

        # 解压到临时目录（zip内包含完整路径，需要处理）
        unzip -q -o "$zipfile" -d "$TEMP_DIR"

        # 查找解压后的正确目录（跳过 Users/hulifeng/Library/... 层级）
        extracted_dir=""
        for item in "$TEMP_DIR"/*; do
            if [ -d "$item" ] && [[ "$(basename "$item")" == "Users" ]]; then
                # 找到了 Users 目录，向下找技能目录
                extracted_dir=$(find "$item" -maxdepth 6 -type d -name "$skill_name" 2>/dev/null | head -1)
                break
            elif [ -d "$item" ] && [[ "$(basename "$item")" == "$skill_name" ]]; then
                # 已经是正确结构
                extracted_dir="$item"
                break
            fi
        done

        if [ -z "$extracted_dir" ] || [ ! -d "$extracted_dir" ]; then
            echo "  ✗ 无法找到解压后的技能目录"
            continue
        fi

        local_skill_dir="$LOCAL_SKILLS_DIR/$skill_name"

        if [ -d "$local_skill_dir" ]; then
            # 比较文件差异
            if ! diff -rq "$extracted_dir" "$local_skill_dir" > /dev/null 2>&1; then
                echo "  → 发现更新，正在替换..."
                rm -rf "$local_skill_dir"
                cp -a "$extracted_dir" "$local_skill_dir"
                ((updated++))
                echo "  ✓ $skill_name 已更新"
            else
                echo "  → 无变化"
            fi
        else
            # 新技能
            echo "  → 发现新技能，正在安装..."
            cp -a "$extracted_dir" "$local_skill_dir"
            ((added++))
            echo "  ✓ $skill_name 已添加"
        fi

        # 清理临时解压文件
        rm -rf "$TEMP_DIR"/*
    fi
done

# 清理
rm -rf "$TEMP_DIR"

echo ""
echo "========== 同步完成 =========="
echo "新增: $added 个技能"
echo "更新: $updated 个技能"
echo "============================="
