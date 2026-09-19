# NovaOS 多用户、权限与审计

> 需求："有多个用户，防止有人乱修改，包括管理员等等"。
> 本文件是 novaos-linux 的账户与审计策略说明，对应
> `desktop/config/hooks/1005-accounts.hook.chroot`。

## 设计原则

| 原则 | 落地 |
|---|---|
| 最小权限 | 所有人用普通账户 + sudo；root 默认锁定 |
| 全量留痕 | sudo 记录输入/输出；auditd 监控身份与配置变更 |
| 管理员也受限 | 管理员 = sudo 组成员，其每次提权都被记录；root 解锁需显式操作 |
| 首次强制改密 | `chage -d 0` 新用户首次登录必须改密码 |
| 会话可追踪 | pam_lastlog 记录上次登录失败/成功信息 |

## 默认策略（hook 实现）

- 默认用户 `novaos`（sudo 组），密码 `novaos`，**首次登录强制修改**
- `passwd -l root` 锁定 root（需要时 `sudo passwd -u root` 显式解锁）
- sudoers 强化：
  - `log_input, log_output` —— 所有 sudo 会话完整记录（含命令输入输出）
  - `timestamp_timeout=5` —— 免密窗口 5 分钟
  - `lecture=always` —— 每次提权显示提醒
- auditd 规则（`/etc/audit/rules.d/novaos.rules`）：
  - sudoers/sudoers.d、passwd/shadow/group/gshadow、sshd_config、
    systemd 单元、crontab、auth.log 的写入与属性变更全部审计
  - 查看审计：`sudo ausearch -k identity`、`sudo aureport -au`

## 用户管理速查

```sh
# 添加用户（自动进 sudo 组）
sudo adduser <name> sudo

# 查看谁在用 sudo / 干了什么
sudo aureport -au          # 认证报告
sudo ausearch -k sudoers   # sudoers 变更记录

# 临时解锁 root（用后立刻锁回）
sudo passwd -u root
sudo passwd -l root
```

## 与 nova-kernel 的关系

自研内核 v0.5 的 ring-3 用户态（U/S 页表保护 + int 0x80 门禁）在**内核层**
提供同样的"防止乱改"能力：用户程序无法读写内核内存、无法绕过系统调用
直接访问硬件。两条线互为印证：发行版管"谁能改"，内核管"能不能越权改"。
