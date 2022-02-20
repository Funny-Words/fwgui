require "gobject/gtk/autorun"
require "./requests.cr"

module FW::GUI
  extend self

  # Gtk Builder
  builder = Gtk::Builder.new_from_file "#{__DIR__}/../data/ui/fw_ui.glade"
  builder.connect_signals

  # About window
  about_button = Gtk::Button.cast builder["about_button"]
  about_window = Gtk::Window.cast builder["about_window"]

  # Word window
  word_window = Gtk::Window.cast builder["word_window"]
  word_label = Gtk::Label.cast builder["word_label"]
  word_text = Gtk::Label.cast builder["word_text"]

  # Buttons
  cword_button = Gtk::Button.cast builder["cword_button"]
  words_button = Gtk::Button.cast builder["words_button"]

  # Words spin
  words_spin = Gtk::SpinButton.cast builder["words_spin"]

  # About buttons handlers
  about_button.on_clicked { about_window.show_all }
  Gtk::Button.cast(builder["about_close_button"]).connect "clicked", &->about_window.hide

  channel = Channel(String).new

  # Button handlers
  cword_button.on_clicked do
    spawn do
      channel.send FW::Requests.get_cword.not_nil!
    end
    cword = channel.receive
    word_text.label = cword
    word_label.label = "Кслово"
    word_window.show_all
  end

  words_button.on_clicked do
    spawn do
      channel.send FW::Requests.get_words(words_spin.value_as_int).not_nil!
    end
    words = channel.receive
    word_text.label = words
    word_label.label = "Слова"
    word_window.show_all
  end

  Gtk::Button.cast(builder["word_window_close_button"]).connect "clicked", &->word_window.hide

  # Window
  window = Gtk::Window.cast builder["main_window"]
  window.show_all
end
