defmodule BoomWeb.ErrorView do
  use BoomWeb, :view

  def render("400.json", %{err_msg: err_msg}) do
    %{errors: %{detail: err_msg}}
  end

  def render("404.json", %{err_msg: err_msg}) do
    %{errors: %{detail: err_msg}}
  end

  def render("404.json", _assigns) do
    %{errors: %{detail: "Page not found"}}
  end

  def render("500.json", _assigns) do
    %{errors: %{detail: "Internal Server Error"}}
  end

  def template_not_found(_template, assigns) do
    render("500.json", assigns)
  end
end
