require 'spec_helper'

describe Variable do

  # - Validations -
  it { should validate_presence_of :name              }
  it { should validate_presence_of :display_name      }
  it { should validate_presence_of :low_value         }
  it { should validate_presence_of :initial_value     }
  it { should validate_presence_of :high_value        }
  it { should validate_numericality_of :low_value     }
  it { should validate_numericality_of :initial_value }
  it { should validate_numericality_of :high_value    }

end
