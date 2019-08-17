workflow "Deploy on Now" {
  on = "push"
  resolves = ["release"]
}

action "deploy" {
  uses = "actions/zeit-now@master"
  args = "--public --no-clipboard deploy . > $HOME/$GITHUB_ACTION.txt"
  secrets = ["ZEIT_TOKEN"]
}

action "alias" {
  needs = "deploy"
  uses = "actions/zeit-now@master"
  args = "alias `cat $HOME/deploy.txt` $GITHUB_SHA"
  secrets = ["ZEIT_TOKEN"]
}

action "master-branch-filter" {
  needs = "alias"
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "release" {
  needs = "master-branch-filter"
  uses = "actions/zeit-now@master"
  secrets = ["ZEIT_TOKEN"]
  args = "alias --local-config=./now.json"
}
