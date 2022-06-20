class Player < Struct.new(:name, :attempts, :date)
  def print_records
    attempts.length==0 ? printf(",") : printf("attempts : %s, ", attempts)
    name.length==0 ? printf(",") : printf("nickname: %s, ", name)
    date.length==0 ? printf("") : printf("date: %s", date)
    printf("\n")
  end
end
