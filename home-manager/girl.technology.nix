{
  Unit = {
    Description = "https://girl.technology";
    After = [
      "network.target"
    ];
    StartLimitIntervalSec = 0;
  };
  Install = {
    WantedBy = [ "default.target" ];
  };
  Service = {
    Type = "simple";
    Restart = "always";
    RestartSec = 1;
    WorkingDirectory = "/home/ubuntu/girl.technology";
    ExecStart = "/home/ubuntu/girl.technology/prod_run.sh";
  };
}
