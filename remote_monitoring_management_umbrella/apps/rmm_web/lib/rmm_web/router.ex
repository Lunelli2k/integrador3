defmodule RmmWeb.Router do
  use RmmWeb, :router
  alias SolucaoContornoController
  alias IncidenteController

  import RmmWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {RmmWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end


  pipeline :api do
    plug :accepts, ["json"]
  end


  scope "/", RmmWeb do
    pipe_through [:api]

    post "/enviar_estado", APIController, :enviar_estado
  end

  scope "/", RmmWeb do
    pipe_through [:browser, :require_authenticated_user]

    live "/monitor", DateLive, :show
  end


  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:rmm_web, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: RmmWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", RmmWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/user/register", UserRegistrationController, :new
    post "/user/register", UserRegistrationController, :create
    get "/user/log_in", UserSessionController, :new
    post "/user/log_in", UserSessionController, :create
    get "/user/reset_password", UserResetPasswordController, :new
    post "/user/reset_password", UserResetPasswordController, :create
    get "/user/reset_password/:token", UserResetPasswordController, :edit
    put "/user/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", RmmWeb do

    pipe_through [:browser, :require_authenticated_user]

    get "/", PageController, :home
  end

  scope "/user", RmmWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/settings", UserSettingsController, :edit
    put "/settings", UserSettingsController, :update
    get "/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/user", RmmWeb do
    pipe_through [:browser]

    delete "/log_out", UserSessionController, :delete
    get "/confirm", UserConfirmationController, :new
    post "/confirm", UserConfirmationController, :create
    get "/confirm/:token", UserConfirmationController, :edit
    post "/confirm/:token", UserConfirmationController, :update
  end

  scope "/itens_configuracao", RmmWeb do
    pipe_through [:browser, :require_authenticated_user]

    resources "/", ItemConfiguracaoController, except: [:create, :delete, :new]
  end

  scope "/solucoes_contorno", RmmWeb do
    pipe_through [:browser,  :require_authenticated_user]

    resources "/", SolucaoContornoController
  end

  scope "/incidentes", RmmWeb do
    pipe_through [:browser, :require_authenticated_user]

    resources "/", IncidenteController
  end

  scope "/regras_eventos_criticidade", RmmWeb do
    pipe_through [:browser, :require_authenticated_user]

    resources "/", RegraEventoCriticidadeController
  end

end
