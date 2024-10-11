let context = #{};

context += prompt("Author:", "author_full", #{
    help: "Author and Email",
});

context += render(Archetype("org-prompts"), ANSWERS);

context += prompt("Chatbots:", "chatbots", #{
  type: List,
  help: "Python-based chatbots",
});

context += prompt("Copilots:", "copilots", #{
  defaults_with: context.chatbots,
  type: List,
  help: "Python-based copilots",
});

context += prompt("Inferencers:", "inferencers", #{
  defaults_with: context.chatbots,
  type: List,
  help: "Python-based inferencers",
});

context += prompt("Trainers:", "trainers", #{
  defaults_with: context.chatbots,
  type: List,
  help: "Python-based model trainers",
});

render_app_set(context.chatbots, "python-project-scaffolding", "Chatbot", context);
render_app_set(context.copilots, "python-project-scaffolding", "Copilot", context);
render_app_set(context.inferencers, "python-project-scaffolding", "Inferencer", context);
render_app_set(context.trainers, "python-project-scaffolding", "Trainer", context);


fn render_app_set(apps, archetype_name, suffix, context) {
    let archetype = Archetype(archetype_name);
    let app_context = #{
      "org-name": context["org-name"],
      "solution-name": context["solution-name"],
      "project-suffix": suffix,
      "transport": "FastAPI",
      "features": [],
      "packages": ["api", "client", "core", "server"],
      "author_full": context["author_full"],
    };
    for app in apps {
      let destination_directory = render("{{ org-name }}-{{ solution-name }}", context);
      log(Info, `Rendering ${pascal_case(app)} ${suffix}`);
      archetype.render(
        destination_directory,
        app_context + #{ "project-prefix": app, }
      );
    }
}