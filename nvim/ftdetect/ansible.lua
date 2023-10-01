local function detect_ansible()
  local is_ansible = require("bti.util").has_ancestor_files({ "ansible.cfg", ".ansible-lint" })

  if is_ansible then
    return "yaml.ansible"
  end

  return "yaml"
end

vim.filetype.add({
  extension = {
    yml = detect_ansible,
    yaml = detect_ansible,
  },
})
