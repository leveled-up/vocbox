<?php
include("core/core.inc.php");

basic_template();
?>
<h2>Howdy, <?=$user->name?>!</h2>
<p>
  Welcome to VocBox, the Vocabulary Trainer that's focused on Machine Learning and AI. Thanks for being here. &hearts;
</p>

<br />

<a href="/new_library" id="index_btn_library_new" class="btn btn-default">
  <i class="fa fa-plus"></i>
  New Library
</a>

<br /> <br />

<table class="table table-striped" id="index_table_libraries">
  <thead>
    <th>Languages</th>
    <th>Comment</th>
    <th>Actions</th>
  </thead>
  <tbody>
    <?php
      $libraries_list_query = query_library_list($user);
      $libraries_list = query($libraries_list_query, false);
      var_dump($libraries_list);

      if(count($libraries_list < 1))
        echo "
        <tr>
          <td>You don't have any libraries yet.</td>
          <td></td>
          <td></td>
        </tr>";
      else
        foreach($libraries_list as $library)
          echo "
          <tr>
            <td>".language_pair_to_text($library["langs"])."</td>
            <td>
              <i>".htmlentities($library["comment"])."</i>
            </td>
            <td></td>
          </tr>";
    ?>
  </tbody>
</table>
