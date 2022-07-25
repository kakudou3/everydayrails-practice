require 'rails_helper'

RSpec.describe Project, type: :model do

  # ユーザー単位では重複したプロジェクト名を許可しないこと
  it "does not allow duplicate project names per user" do
    user = User.create(
      first_name: "Joe",
      last_name:  "Tester",
      email:      "joetester@example.com",
      password:   "dottle-nouveau-pavilion-tights-furze"
    )
    user.projects.create(
      name: "Test Project"
    )
    new_project = user.projects.build(
      name: "Test Project"
    )
    new_project.valid?
    expect(new_project.errors[:name]).to include("has already been taken")
  end

  # 二人のユーザーが同じ名前を使うことは許可すること
  it "allows two users to share a project name" do
    user = User.create(
      first_name: "Joe",
      last_name: "Tester",
      email: "joetester@example.com",
      password: "dottle-nouveau-pavilion-tights-furze"
    )

    user.projects.create(
      name: "Test Project"
    )

    other_user = User.create(
      first_name: "Jane",
      last_name: "Tester",
      email: "janetester@example.com",
      password: "dottle-nouveau-pavilion-tights-furze"
    )

    other_project = other_user.projects.build(
      name: "Test Project"
    )

    expect(other_project).to be_valid
  end

  # プロジェクトが遅延している場合は真が返ること
  it "returns true when project after due_on" do
    user = User.create(
      first_name: "Joe",
      last_name:  "Tester",
      email:      "joetester@example.com",
      password:   "dottle-nouveau-pavilion-tights-furze"
    )
    project = user.projects.create(
      name: "Test Project",
      due_on: Time.zone.yesterday
    )

    expect(project.late?).to be_truthy
  end

  # プロジェクトが遅延していない場合は偽が返ること
  it "returns false when project before due_on" do
    user = User.create(
      first_name: "Joe",
      last_name:  "Tester",
      email:      "joetester@example.com",
      password:   "dottle-nouveau-pavilion-tights-furze"
    )
    project = user.projects.create(
      name: "Test Project",
      due_on: Time.zone.tomorrow
    )

    expect(project.late?).to be_falsey
  end
end
