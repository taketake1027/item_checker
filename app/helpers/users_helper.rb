module UsersHelper
  def role_to_japanese(role)
    case role
    when 'employee'
      '社員'
    when 'staff'
      'スタッフ'
    when 'leader'
      '責任者'
    else
      '不明'
    end
  end
end
