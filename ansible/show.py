import subprocess
import yaml

def parseYaml(path: str) -> dict:
    d = {}
    with open(path, 'r') as f:
        d = yaml.load(f, Loader=yaml.FullLoader)
    return d

def getUrl(var: dict, key: str) -> str:
    dn = var['base']['envoy']['domain']
    i = var[key]['external'].find('.')
    sd = var[key]['external'][0:i]
    return 'https://{}.{}'.format(sd, dn)

def genDashboardToekn(inv: dict) -> str:
    # Make ssh command
    host = inv['cluster']['hosts']['cp0']['ansible_host']
    user = inv['cluster']['hosts']['cp0']['ansible_user']
    jump = []
    if inv['cluster']['hosts']['cp0'].get('ansible_ssh_common_args'):
        jump = inv['cluster']['hosts']['cp0']['ansible_ssh_common_args'].split()
    cmd = ['ssh'] + jump + [user + '@' + host] + ['kubectl', 'create', 'token', '-n', 'kubernetes-dashboard', 'admin-user']
    # Execute the commnad and return the result
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE)	
    stdout, _ = p.communicate()
    return stdout.decode('utf-8')

if __name__ == '__main__':
    inv = parseYaml('inventories/vbox.yaml')
    var = parseYaml('playbooks/vars.yaml')

    # Show dns Info
    print('[DNS]')
    print(' |_ IP:', inv['dns']['hosts']['dns0']['ansible_host'])
    # Show registry info
    print('[REGISTRY]')
    print(' |_ URL:', getUrl(var, 'harbor'))
    print(' |_ Admin ID:', 'admin')
    print(' |_ Admin PW:', var['base']['harbor']['pw'])
    # Show scm info
    print('[SCM]')
    print(' |_ URL:', getUrl(var, 'gitea'))
    print(' |_ Admin ID:', var['base']['gitea']['admin_id'])
    print(' |_ Admin PW:', var['base']['gitea']['admin_pw'])
    print(' |_ User jenkins ID:', var['base']['gitea']['jenkins_id'])
    print(' |_ User jenkins PW:', var['base']['gitea']['jenkins_pw'])
    # Show ci info
    print('[CI]')
    print(' |_ URL:', getUrl(var, 'jenkins'))
    print(' |_ Admin ID: admin')
    with open('playbooks/.keep/jenkins-admin-pw', 'r') as f:
        print(' |_ Admin PW:', f.read(), end='')
    # Show k8s dashboard info
    print('[K8s]')
    print(' |_ Dashboard IP:', var['base']['dashboard']['ip'])
    print(' |_ Dashboard Token: Generating... (Old one will be expired)')
    print(genDashboardToekn(inv))

