import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  //Load the React code when we initialize
  initialize() {
    this.componentPromise = import("./react/editor");
  }

  async connect() {
    this.component = await this.componentPromise;

    const root = this.targets.find("root");
    const contentField = this.targets.find("contentField");
    const titleField = this.targets.find("titleField");
    const railsForm = this.targets.find("form");

    const onCancelButton = () => {
      if (confirm("Cancel without saving?")) {
        window.location.href = "/projects";
      }
    }

    const onSaveButton = () => {
      if (confirm("Save and exit?")) {
        railsForm.submit();
      }
    }

    const props = {
      content: contentField.value,
      onContentChange: (v) => contentField.value = v,
      title: titleField.value,
      onTitleChange: (v) => titleField.value = v,
      onSaveButton: onSaveButton,
      saveButtonLabel: "Save and...",
      onCancelButton: onCancelButton,
      cancelButtonLabel: "Cancel"
    };

    this.component.render(root, props);
  }

  disconnect() {
    const root = this.targets.find("root");

    this.component.destroy(root);
  }
}
