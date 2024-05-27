CATATAN UAS:

Telah ditambahkan cheatcodes yang dapat digunakan oleh player!
Untuk menggunakan cheatcode, tulis cheat berikut dengan keyboard saat memainkan game.

- imrich
Tulis saat ada di bagian main menu. Cheat ini akan memberikan player 5000 coins secara instant!

- superfast
Tulis saat ada di level permainan. Cheat ini akan menaikkan movement speed player menjadi 450 selama 15 detik!

- bodybuilder
Tulis saat ada di level permainan. Cheat ini akan menaikkan maximum carry weight player menjadi 6000 selama 15 detik!

Polishing game:
Telah dilakukan polishing di bagian animasi saat player mempunyai terlalu banyak barang di inventory. Sebelumnya, jika player memiliki terlalu banyak barang di inventory, maka animasi jalan player akan menjadi sangat lambat, dan dirasa tidak sesuai dengan movement speed yang juga berkurang seiring banyaknya barang di inventory. Polishing dilakukan agar player memiliki feel yang sepadan antara movement speed yang berkurang, dengan animasi jalan yang akan melambat.

Perubahan ini ada di line 147 di player.gd
dari:
$AnimatedSprite.speed_scale = max(0.3, 1.0 - weight_percentage) * default_animation_speed
menjadi:
$AnimatedSprite.speed_scale = max(0.5, 1.0 - weight_percentage) * default_animation_speed