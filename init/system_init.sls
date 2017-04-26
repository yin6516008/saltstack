system-init:
  copy_aliyun:
    file.managed:
      - name: /etc/yum.repos.d/CentOS-Base.repo
      - source: salt://init/files/CentOS-Base.repo
  
  epel_install:
    pkg.installed:
      - name: epel-release

  change_epel:
    cmd.run:
      - name: sed -i "s/^#baseurl/baseurl/g"  /etc/yum.repos.d/epel.repo && sed -i "s/^#baseurl/baseurl/g"  /etc/yum.repos.d/epel.repo
    
  install_pkg:
    - name:
      - vim
      - net-tools
      - lsof
      - salt-minion
      - tree
      - wget

