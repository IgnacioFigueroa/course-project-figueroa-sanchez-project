function searchInBlackList() {
    // Declare variables
    var input, filter, table, tr, td, i, txtValue;
    input = document.getElementById("blackListSearcher");
    filter = input.value.toUpperCase();
    table = document.getElementById("blackListTable");
    tr = table.getElementsByTagName("tr");

    for (i = 0; i < tr.length; i++) {
        td = tr[i].getElementsByTagName("td")[1];
        if (td) {
            txtValue = td.textContent || td.innerText;
            if (txtValue.toUpperCase().indexOf(filter) > -1) {
                tr[i].style.display = "";
            } else {
                tr[i].style.display = "none";
            }
        }
    }
}