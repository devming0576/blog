#!/bin/bash

# 检查是否在 Git 仓库中
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "错误：当前目录不是 Git 仓库！"
    exit 1
fi

# 提示输入 commit message
echo "请输入 commit message："
read commit_message

# 确保输入了 commit message
if [ -z "$commit_message" ]; then
    echo "错误：commit message 不能为空！"
    exit 1
fi

# 在 yimgao/feat 分支提交更改
echo "切换到 yimgao/feat 分支..."
git checkout yimgao/feat || { echo "切换到 yimgao/feat 失败！"; exit 1; }
git add . || { echo "添加文件失败！"; exit 1; }
git commit -m "$commit_message" || { echo "提交更改失败！"; exit 1; }
git push origin yimgao/feat || { echo "推送 yimgao/feat 失败！"; exit 1; }

# 合并到 yimgao/develop
echo "切换到 yimgao/develop 分支..."
git checkout yimgao/develop || { echo "切换到 yimgao/develop 失败！"; exit 1; }
git pull origin yimgao/develop || { echo "拉取 yimgao/develop 失败！"; exit 1; }
git merge yimgao/feat || { echo "合并 yimgao/feat 到 yimgao/develop 失败！"; exit 1; }
git push origin yimgao/develop || { echo "推送 yimgao/develop 失败！"; exit 1; }

# 合并到 main
echo "切换到 main 分支..."
git checkout main || { echo "切换到 main 失败！"; exit 1; }
git pull origin main || { echo "拉取 main 失败！"; exit 1; }
git merge yimgao/develop || { echo "合并 yimgao/develop 到 main 失败！"; exit 1; }
git push origin main || { echo "推送 main 失败！"; exit 1; }

echo "所有操作成功完成！"