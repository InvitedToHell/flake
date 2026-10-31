{
  config,
  pkgs,
  lib,
  ...
}:

{
  systemd.tmpfiles.rules = [
    "d '${config.services.forgejo.customDir}/public/assets/img' - forgejo forgejo - -"
    "d '${config.services.forgejo.customDir}/public/assets/css' - forgejo forgejo - -"
    "d '${config.services.forgejo.customDir}/templates/base' - forgejo forgejo - -"

    "C+ '${config.services.forgejo.customDir}/templates/base/footer_content.tmpl' - forgejo forgejo - ${./templates/base/footer_content.tmpl}"
    "C+ '${config.services.forgejo.customDir}/templates/base/footer.tmpl' - forgejo forgejo - ${./templates/base/footer.tmpl}"
    "C+ '${config.services.forgejo.customDir}/templates/home.tmpl' - forgejo forgejo - ${./templates/home.tmpl}"

    "C+ '${config.services.forgejo.customDir}/public/assets/img/favicon.svg' - forgejo forgejo - ${./assets/icon.svg}"
    "C+ '${config.services.forgejo.customDir}/public/assets/img/favicon.png' - forgejo forgejo - ${./assets/icon.png}"
    "C+ '${config.services.forgejo.customDir}/public/assets/img/favicon.ico' - forgejo forgejo - ${./assets/icon.ico}"
    "C+ '${config.services.forgejo.customDir}/public/assets/img/logo.svg' - forgejo forgejo - ${./assets/icon.svg}"
    "C+ '${config.services.forgejo.customDir}/public/assets/img/logo.ico' - forgejo forgejo - ${./assets/icon.ico}"
    "C+ '${config.services.forgejo.customDir}/public/assets/img/logo.png' - forgejo forgejo - ${./assets/icon.png}"
    "C+ '${config.services.forgejo.customDir}/public/assets/img/apple-touch-icon.png' - forgejo forgejo - ${./assets/icon.png}"
    "C+ '${config.services.forgejo.customDir}/public/assets/img/home-header.jpg' - forgejo forgejo - ${./assets/home-header.jpg}"

    "C+ '${config.services.forgejo.customDir}/public/assets/css/theme-void-iridescent.css' - forgejo forgejo - ${./themes/theme-void-iridescent.css}"
    "C+ '${config.services.forgejo.customDir}/public/assets/css/theme-void-amethyst.css' - forgejo forgejo - ${./themes/theme-void-amethyst.css}"
    "C+ '${config.services.forgejo.customDir}/public/assets/css/theme-void-emerald.css' - forgejo forgejo - ${./themes/theme-void-emerald.css}"
    "C+ '${config.services.forgejo.customDir}/public/assets/css/theme-void-moonstone.css' - forgejo forgejo - ${./themes/theme-void-moonstone.css}"
    "C+ '${config.services.forgejo.customDir}/public/assets/css/theme-void-ruby.css' - forgejo forgejo - ${./themes/theme-void-ruby.css}"
    "C+ '${config.services.forgejo.customDir}/public/assets/css/theme-void-sapphire.css' - forgejo forgejo - ${./themes/theme-void-sapphire.css}"
    "C+ '${config.services.forgejo.customDir}/public/assets/css/theme-void-topaz.css' - forgejo forgejo - ${./themes/theme-void-topaz.css}"
  ];

  services.forgejo = {
    enable = true;
    package = pkgs.forgejo;
    useWizard = false;
    dump.enable = false;

    stateDir = "/var/lib/forgejo";
    customDir = "/var/lib/forgejo/custom";
    repositoryRoot = "/var/lib/forgejo/repositories";

    lfs = {
      enable = true;
      contentDir = "/var/lib/forgejo/data/lfs";
    };

    database = {
      createDatabase = true;
      type = "postgres";
      user = "forgejo";
      name = "forgejo";
      socket = "/run/postgresql";
      port = 5432;
    };

    settings = {
      DEFAULT = {
        APP_NAME = "pompomsoft";
        APP_SLOGAN = "git for pompomsoft";
        DEFAULT_PRIVATE = "private";
        DEFAULT_BRANCH = "main";
      };

      log = {
        ROOT_PATH = "/var/lib/forgejo/log";
        LEVEL = "Warn";
      };

      server = {
        ROOT_URL = "https://git.pompomsoft.de";
        DISABLE_SSH = false;
        PROTOCOL = "http";
        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = 3000;
        DOMAIN = "git.pompomsoft.de";
      };

      ui = {
        DEFAULT_THEME = "void-iridescent";
        THEMES = "void-iridescent,void-amethyst,void-emerald,void-moonstone,void-ruby,void-sapphire,void-topaz,forgejo-auto,forgejo-dark,forgejo-light,gitea-auto,gitea-light,gitea-dark,forgejo-auto-deuteranopia-protanopia,forgejo-light-deuteranopia-protanopia,forgejo-dark-deuteranopia-protanopia,forgejo-auto-tritanopia,forgejo-light-tritanopia,forgejo-dark-tritanopia";
        MAX_DISPLAY_FILE_SIZE = 33554432;
      };

      api.ENABLE_SWAGGER = false;

      openid = {
        ENABLE_OPENID_SIGNIN = false;
        ENABLE_OPENID_SIGNUP = false;
      };

      oauth2 = {
        ENABLED = true;
      };

      oauth2_client = {
        ENABLE_AUTO_REGISTRATION = true;
      };

      other.SHOW_FOOTER_VERSION = false;

      service = {
        DISABLE_REGISTRATION = true;
        DEFAULT_KEEP_EMAIL_PRIVATE = true;
        DEFAULT_USER_VISIBILITY = "limited";
        ALLOWED_USER_VISIBILITY_MODES = "public,limited,private";
        DEFAULT_ORG_VISIBILITY = "limited";
        DEFAULT_ORG_MEMBER_VISIBLE = true;
        REQUIRE_SIGNIN_VIEW = false;
      };

      session.COOKIE_SECURE = true;

      mailer.ENABLED = false;
      actions.ENABLED = true;

      migrations.ALLOW_LOCALNETWORKS = true;
    };
  };

  services.caddy.virtualHosts."git.pompomsoft.de".extraConfig = ''
    reverse_proxy 127.0.0.1:3000
  '';
}
